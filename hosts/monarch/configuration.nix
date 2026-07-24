# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  pkgs,
  ...
}:

{

  #Modules in the ./modules/system
  modules.system = {
    auto-cpufreq.enable = true;
    shells.enable = true;
    de.enable = true;
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #networking.hostName = "monarch"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Enable the proprietary drivers
  hardware.enableRedistributableFirmware = true;
  hardware.enableAllFirmware = true;
  # Load amdgpu at stage 1
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.kernelModules = [ "amdgpu" "hp-wmi" ];
  boot.kernelParams = [
    # Force use of the thinkpad_acpi driver for backlight control.
    # This allows the backlight save/load systemd service to work.
    "acpi_backlight=native"

    # AMD CPU scaling
    # https://www.kernel.org/doc/html/latest/admin-guide/pm/amd-pstate.html
    # https://wiki.archlinux.org/title/CPU_frequency_scaling#amd_pstate
    # On recent AMD CPUs this can be more energy efficient.
    "amd_pstate=active"

    # Load amdgpu at stage 1
    "amdgpu"

    # With BIOS version 1.12 and the IOMMU enabled, the amdgpu driver
    # either crashes or is not able to attach to the GPU depending on
    # the kernel version. I've seen no issues with the IOMMU disabled.
    #
    # BIOS version 1.13 fixes the IOMMU issues, but we leave the IOMMU
    # in software mode to avoid a sad experience for those people that drew
    # the short straw when they bought their laptop.
    #
    # Do not set iommu=off, because this will cause the SD-Card reader
    # driver to kernel panic.
    "iommu=soft"
    "usbcore.autosuspend=-1"
  ];


  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  #Enabling Flakes in Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  #Enabling non-free packages
  nixpkgs.config.allowUnfree = true;

  #Configuring Hardware-Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      # VA-API and VDPAU
      libva-vdpau-driver

      # AMD ROCm OpenCL runtime
      rocmPackages.clr
      rocmPackages.clr.icd

    ];
  };
  services.xserver.videoDrivers = [ "amdgpu" ];
  environment.variables = {
    # VAAPI and VDPAU config for accelerated video.
    # See https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    "VDPAU_DRIVER" = "radeonsi";
    "LIBVA_DRIVER_NAME" = "radeonsi";
  };

  #HIP libraries workaround fix;

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  # disable the powerprofiles daemon because it hates auto-cpufreq
  services.power-profiles-daemon.enable = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  security.polkit.enable = true;

  #Configuring the xdg-portal for hyprland

  #Enabling flatpak
  services.flatpak.enable = true;
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.geronimo = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "networkmanager"
      "wayland"
      "kvm"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  #Enable power management
  powerManagement.enable = true;

  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    gcc
    git
    radeontop
    acpid
    #dunst
    xwayland-satellite
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    wlroots
    xdg-user-dirs
    xdg-utils
    xwayland
    libnotify
    libcamera
    v4l-utils

    # app-launchers
    fuzzel

    # audio-controls
    pavucontrol
    pipewire

    #Fonts
    #(nerd-fonts.override { fonts = [ "FiraCode" ]; })
  ];
  # Should steam be in be here?
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  #GNOME related stuff
  #services.gnome.gnome-keyring.enable = true;
  #services.gvfs.enable = true;

  #Docker setup
  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
    daemon.settings = {
      "data-root" = "/home/docker-root";
    };
  };

  #Enable direnvs
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Enable ld for code editors
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
  ];
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    #openFirewall = true;
  };

  #Tailscale setup
  services.tailscale.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

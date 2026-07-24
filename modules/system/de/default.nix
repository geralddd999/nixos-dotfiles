{config, lib, pkgs, inputs, ...}:
let
  cfg = config.modules.system.de;

in
{
  options.modules.system.de = {
    enable = lib.mkEnableOption "Change the desktop environnments";
  };


  config = lib.mkIf cfg.enable{
    # Niri config
    programs.niri = {
      enable = true;
    };

    #GNOME config
    #services.displayManager.gdm.enable = true;
    #services.desktopManager.gnome.enable = true;
    #services.xserver.enable = true;

    #services.gnome = {
    #  core-apps.enable = true;
    #  core-developer-tools.enable = false;
    #  games.enable = false;
    #  gnome-keyring.enable = true;
    #};
    #services.gvfs.enable = true;

    #xdg.portal = {
    #  enable = true;
    #  # Use gnome portal for GNOME and gtk/wlr for Niri
    #  extraPortals = [
    #    pkgs.xdg-desktop-portal-gnome
    #    pkgs.xdg-desktop-portal-gtk
    #  ];
    #  config.common.default = [ "gnome" "gtk" ];
    #};

    #environment.gnome.excludePackages = [ pkgs.gnome-tour pkgs.gnome-user-docs ];

    #environment.systemPackages = with pkgs; [
    #  gnomeExtensions.blur-my-shell
    #  gnomeExtensions.just-perfection
    #  gnomeExtensions.dash-to-dock
    #  gnomeExtensions.appindicator
    #  gnomeExtensions.gsconnect
    #  gnome-tweaks
    #  adwaita-icon-theme
    #  gnomeExtensions.user-themes
    #  gnomeExtensions.paperwm
    #];


    # --------------------
    # KDE CONFIG
    # --------------------
    services.power-profiles-daemon.enable = false;

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.xserver.enable = true;

    services.desktopManager.plasma6.enable = true;
    environment.plasma6.excludePackages = [ pkgs.kdePackages.elisa ];

    environment.systemPackages = [
      #kde-rounded-corners
      #kdePackages.krohnkite
      pkgs.plasma-panel-colorizer
      pkgs.mpvpaper
      # Noctalia DE for Niri 
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
    
    # -----------------------
    # PORTAL CONFIG
    # -----------------------
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde
              pkgs.xdg-desktop-portal-gtk
              pkgs.xdg-desktop-portal-gnome];

      config = {
        kde = {
          default = ["kde"];
        };
        niri = {
          default = lib.mkForce["kde" "gtk"];
        };
      };
    };


    services.dbus.enable = true;
    programs.dconf.enable = true;

    services.gnome.gnome-online-accounts.enable = true;
    services.gnome.evolution-data-server.enable = true;


    services.gnome.gnome-keyring.enable = true;
    security.pam.services.sddm.enableGnomeKeyring = true;
  };
}

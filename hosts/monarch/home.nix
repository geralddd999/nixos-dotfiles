{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
#removed apple-fonts
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  imports = [
    #./dunst.nix
    #./matlab.nix
  ];
  home.username = "geronimo";
  home.homeDirectory = "/home/geronimo";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.
  # The home.packages option allows you to install Nix packages into your
  # environment.
  #
  userSettings = {

    dunst.enable = false;
    # IDE - text editors
    zed.enable = true;
    nvim.enable = true;

    # Office - productivity
    office.enable = true;

    # School related stuff
    engineering.enable = true;
    # VM-s docker
    virtualization.winapps.enable = true;

    comms.enable = true;

    # Noctalia
    noctalia.enable = true;
  };

  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    omnissa-horizon-client
    openconnect
    anytype
    man-pages
    grim
    lazygit
    ghostty
    ascii-image-converter

    material-symbols
    matugen
    glib

    powertop
    fastfetch
    libgtop
    gsettings-desktop-schemas
    fish
    btop
    python3
    lshw
    gnumake
    ripgrep
    fd
    unzip
    libsoup_3
    upower
    dart-sass
    shared-mime-info
    desktop-file-utils

    #networking and others
    bluez
    bluez-tools
    #Qt apps
    kdePackages.dolphin
    # Qt/QML dev
    qtcreator
    #dolphin related
    kdePackages.kirigami
    kdePackages.kio
    kdePackages.kdf
    kdePackages.kio-fuse
    kdePackages.kio-extras
    kdePackages.kio-admin
    kdePackages.qtwayland
    kdePackages.plasma-integration
    kdePackages.kdegraphics-thumbnailers
    kdePackages.breeze-icons
    kdePackages.qtsvg
    kdePackages.kservice
    kdePackages.kde-cli-tools

    kdePackages.kate
    kdePackages.ark
    kdePackages.okular
    kdePackages.gwenview
    kdePackages.systemsettings
    # Gnome related stuff + File manager:
    nautilus
    gnome-music
    easyeffects
    gnome-photos
    gnome-characters
    sassc
    # git related
    gh
    git
    #Wayland related pkgs:
    grim
    slurp
    wl-clipboard
    wtype
    pamixer
    #syntax highlighting
    kdePackages.syntax-highlighting

    #Other
    grimblast
    freerdp
    dialog
    iproute2
    remmina
    # Niri deps+ other dependencies
    awww
    grim
    wlogout
    wofi
    playerctl
    nwg-look
    brightnessctl

    #dev/nonfree
    vscode
    #microsoft-edge
    zed-editor
    inputs.zen.packages.${pkgs.system}.default
    nil
    # C++ dev packages
    clang
    nixd
    clang-tools
    clang-manpages
    cmake
    valgrind
    codespell
    cppcheck
    gdb

    #Word-processing / school related
    obsidian
    onlyoffice-desktopeditors
    libreoffice-qt
    hunspell

    #fonts
    meslo-lgs-nf
    liberation_ttf
    #lsps
    #gaming
    #lutris
    prismlauncher

    inputs.apple-fonts.packages.${pkgs.system}.sf-pro
    #nerd-fonts.jetbrains-mono

    jetbrains.idea

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  fonts.fontconfig.enable = true;
  # stylix.fonts = {
  #   serif = {
  #     package = inputs.apple-fonts.packages.${pkgs.system}.sf-pro-nerd;
  #     name = "SFProDisplay Nerd Font";
  #   };
  # };

  programs.waybar = {
    enable = false;
    #style = ./waybar/style.css;
    #settings = {
    #  main = builtins.fromJSON (builtins.readFile ./waybar/config);
    #};
    #style = builtins.readFile ./waybar/style.css;

  };

  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  # Shell config for Niri
  #Shell config

    #xdg.configFile."quickshell" = {
  #source = config.lib.file.mkOutOfStoreSymlink
  #"${config.home.homeDirectory}/.dotfiles/quickshell";
  # recursive = true;
  #};

  #xdg.enable = true;

  #xdg.mimeApps = {
  #  enable = true;
  #  defaultApplications = {
  #    #i hate you dolphin
  #    #text + code
  #    "text/plain" = "org.kde.kate.desktop";
  #    "text/x-python" = "code.desktop";
  #    "text/x-c++src" = "code.desktop";
  #    "text/x-csrc" = "code.desktop";
  #    "text/x-shellscript" = "org.kde.kate.desktop";
  #    #folders
  #    "inode/directory" = "org.kde.dolphin.desktop";
  #    #images
  #    "image/*" = "org.kde.gwenview.desktop";
  #
  #    "application/pdf" = "org.kde.okular.desktop";
  #
  #   "application/zip" = "org.kde.ark.desktop";
  #   "application/x-compressed-tar" = "org.kde.ark.desktop";
  #    "application/x-bzip-compressed-tar" = "org.kde.ark.desktop";
  #    "application/x-xz-compressed-tar" = "org.kde.ark.desktop";
  #    "application/gzip" = "org.kde.ark.desktop";
  #  };
  #  associations.added = {
  #    "text/plain" = [ "code.desktop" ];
  #    "application/pdf" = [ "zen-beta.desktop" ];
  #  };
  #};
  #making kde filepicker the default
  xdg.configFile."xdg-desktop-portal/niri-portals.conf" = {
    text = ''
      [preferred]
      default = niri;gtk
      org.freedesktop.impl.portal.FileChooser = kde
    '';
  };
  #Git config
  programs.git = {
    enable = true;
    settings.user = {
      name = "Gerald Chambi";
      email = "chambigerald@hotmail.com";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };
  #appearence config [kde]
  #qt = {
  #  enable = true;
  #  platformTheme.name = "qt6ct";
  #  style.name = "kvantum";
  #};

  #Appearence config [GNOME] | don't know if this is necessary
  gtk = {
    enable = true;

    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };

    gtk4.extraConfig = {
      gtk-theme-name = "adw-gtk3-dark";
      gtk-icon-theme-name = "Adwaita";
      gtk-font-name = "SF Pro 11";
      gtk-cursor-theme-name = "Adwaita";
      gtk-cursor-theme-size = 24;
      gtk-application-prefer-dark-theme = 1;

    };

    gtk3.extraConfig = {
      gtk-theme-name = "adw-gtk3-dark";
      gtk-icon-theme-name = "Adwaita";
      gtk-font-name = "SF Pro 11";
      gtk-cursor-theme-name = "Adwaita";
      gtk-cursor-theme-size = 24;
      gtk-application-prefer-dark-theme = 1;

    };

    #gtk3.extraCss = builtins.readFile ./gtk/gtk-3.0/gtk.css;
    #gtk4.extraCss = builtins.readFile ./gtk/gtk-4.0/gtk.css;
  };

  #apply dark theme to gnome apps
  #dconf.enable = true;
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      #to yet to configure the fractional scaling because i'm too lazy to actually check for it
    };
  };

  #programs.neovim = {
  #  enable = true;
  #};
  #kde-connect | file sharing between devices setup
  services.kdeconnect = {
    enable = true;
  };

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    #".config/wofi/config" = {
    #  source = ./wofi/config;
    #};
    #".config/wofi/style.css" = {
    #  source = ./wofi/style.css;
    #};
    #".config/wofi/colors.css" = {
    #  source = ./wofi/colors.css;
    #};
    #Gtk related stuff
    #".config/gtk-4.0/colors.css" = {
    #  source = ./gtk/gtk-4.0/colors.css;
    #};
    #".config/gtk-3.0/colors.css" = {
    #  source = ./gtk/gtk-3.0/colors.css;
    #};

    ##kde-qt related stuff
    #".config/qt6ct/qt6ct.conf" = {
    #  source = ./kde-qt/qt6ct.conf;
    #};

    ##kitty config
    #".config/kitty/kitty.conf" = {
    #  source = ./kitty/kitty.conf;
    #};
    #".config/kitty/colors.conf" = {
    #  source = ./kitty/colors.conf;
    #};

    ##matugen
    #".config/matugen/config.toml" = {
    #  source = ./matugen/config.toml;
    #};

  };

  #xdg.configFile = {
  #  "waybar/config".source =
  #    config.lib.file.mkOutOfStoreSymlink "/home/geronimo/Other/dotfiles/waybar/config";
  #  "waybar/style.css".source =
  #    config.lib.file.mkOutOfStoreSymlink "/home/geronimo/Other/dotfiles/waybar/style.css";
  #};

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/geronimo/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    #QML_IMPORT_PATH = "${pkgs.quickshell}/lib/qt-6/qml";
    #QML2_IMPORT_PATH = "${pkgs.quickshell}/lib/qt-6/qml";
    XDG_MENU_PREFIX = "kde-";

    EDITOR = "vim";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

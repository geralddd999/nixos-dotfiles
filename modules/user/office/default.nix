{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.userSettings.office;
in
{
  options.userSettings.office.enable = lib.mkEnableOption "Enable office - writing programs";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      shared-mime-info
      kdePackages.dolphin
      kdePackages.dolphin-plugins

      libreoffice-qt
      adwaita-icon-theme
      #beeper
      hunspell
      hunspellDicts.en_US

      obsidian
      anytype
      zotero
      gnome-calendar
    ];
  };
}

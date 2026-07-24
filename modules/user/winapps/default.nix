{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.userSettings.virtualization.winapps;
in
{
  options.userSettings.virtualization.winapps = {
    enable = lib.mkEnableOption "Enable VM apps";
  };

  # other essential modules installed as system packages yo!

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.winapps.packages.${pkgs.system}.winapps
      inputs.winapps.packages.${pkgs.system}.winapps-launcher
      dosfstools
      freerdp
    ];

    #winapps config file
    #xdg.configFile."winapps/winapps.conf" = {
    #  source = ./winapps.conf;
    #};

  };
}

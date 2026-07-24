{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.userSettings.noctalia;
in
{
  options = {
    userSettings.noctalia = {
      enable = lib.mkEnableOption "Enable noctalia personalized config";
    };
  };

  config = lib.mkIf cfg.enable {
    
    #userSettings.matlab.enable = true;
    programs.noctalia = {
      enable = true;
      
      settings ={
        wallpaper = {
          enabled = true;
        };
      };
    };
  };
}


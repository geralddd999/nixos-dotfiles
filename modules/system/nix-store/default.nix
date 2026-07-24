{ lib, ... }:
{
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true; 

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;
  boot.loader.systemd-boot.configurationLimit = 10;  # stop /boot filling up too
}

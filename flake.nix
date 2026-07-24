{
  description = "geronimo's flake managing the NixOS and home-manager separetely (hopefully it works yay!)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
      
    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    apple-fonts.inputs.nixpkgs.follows = "nixpkgs";

    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  # Cachix repo for Noctalia
  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      username = "geronimo";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      lib = nixpkgs.lib;

      hosts = builtins.filter (x: x != null) (
        lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (
          builtins.readDir ./hosts
        )
      );
    in
    {
      # System (NixOS) configuration
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = lib.nixosSystem {
            inherit system;

            specialArgs = {
              inherit inputs username host;
            };

            modules = [
              { networking.hostName = host; }
              (./hosts + "/${host}")

              ./modules/system
            ];
          };
        }) hosts
      );

      # home-manager config (standalone yo!)
      #
      homeConfigurations = builtins.listToAttrs (
        map (host: {
          name = "${username}@${host}";
          value = inputs.home-manager.lib.homeManagerConfiguration {
            inherit pkgs;

            extraSpecialArgs = {
              inherit inputs username host;
            };

            modules = [
              (./hosts + "/${host}/home.nix")

              ./modules/user

              # External modules
              inputs.stylix.homeModules.stylix

            ];
          };
        }) hosts
      );
    };

}

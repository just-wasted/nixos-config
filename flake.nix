{
  description = "system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nix-flatpak,
      home-manager,
      lanzaboote,
      ...
    }:

    let

      system = "x86_64-linux";

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

    in

    {
      nixosConfigurations.missingno = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit pkgs-unstable;
        };

        modules = [

          nix-flatpak.nixosModules.nix-flatpak
          ./configuration.nix
          ./greeter.nix
          ./flatpaks.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.backupFileExtension = "BAK";
            home-manager.useGlobalPkgs = true;
            home-manager.users.wasted =
              { pkgs, ... }:
              {
                imports = [
                  ./home.nix
                ];
              };
          }

          lanzaboote.nixosModules.lanzaboote

          (
            {
              lib,
              config,
              ...
            }:
            {
              boot.loader.systemd-boot.enable = lib.mkForce false;

              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            }
          )
        ];
      };
    };
}

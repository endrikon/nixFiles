{
  description = "flake for nixos setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xmonad-session.url = "github:endrikon/.xmonad";
    gitu.url = "github:altsem/gitu";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    xmonad-session,
    gitu,
    ...
  } @ attrs: let
    mkSystem = {
      extraModules ? [],
      extraHomeManagerConfigs ? {},
      defaultUser ? "endrit",
      name ? "Endrit Konjuhi",
      email,
      system ? "x86_64-linux",
      nixosSystem ? nixpkgs.lib.nixosSystem,
      flake ? "/home/endrit/nixFiles",
      ...
    }:
      nixosSystem {
        inherit system;
        specialArgs =
          attrs
          // {
            inherit defaultUser;
          };

        modules =
          [
            (import ./base.nix {inherit defaultUser flake;})
            ./desktop.nix
            home-manager.nixosModules.home-manager
            ({pkgs, ...}: (import ./home-manager {
              inherit
                pkgs
                system
                gitu
                defaultUser
                name
                email
                extraHomeManagerConfigs
                ;
            }))
            xmonad-session.nixosModules.default
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      laptop = mkSystem {
        email = "29706861+endrikon@users.noreply.github.com";
        extraModules = [
          ./configurations/configuration.nix
        ];
      };
      lenovo = mkSystem {
        email = "29706861+endrikon@users.noreply.github.com";
        extraModules = [
          ./configurations/lenovo-configuration.nix
        ];
        extraHomeManagerConfigs = import ./home-manager/lenovo-configs.nix;
      };
    };

    helpers = {
      inherit mkSystem;
      utils = import ./utils;
    };
  };
}

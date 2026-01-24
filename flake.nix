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
      defaultUser ? "endrit",
      system ? "x86_64-linux",
      nixosSystem ? nixpkgs.lib.nixosSystem,
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
            ./base.nix
            ./desktop.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${defaultUser} = {pkgs, ...}:
                import ./home.nix {
                  inherit
                    pkgs
                    system
                    gitu
                    defaultUser
                    ;
                };
            }
            xmonad-session.nixosModules.default
          ]
          ++ extraModules;
      };
  in {
    nixosConfigurations = {
      laptop = mkSystem {
        extraModules = [
          ./configurations/configuration.nix
        ];
      };
    };

    helpers = {
      inherit mkSystem;
    };
  };
}

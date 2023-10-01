# /etc/nixos/flake.nix
{
  description = "flake for nixos setup";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    xmonad-session.url = "github:Tigatoo/.xmonad";
  };

  outputs = { self, nixpkgs, home-manager, xmonad-session, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.endrit = import ./home.nix;
          }
          xmonad-session.nixosModules.default
        ];
      };
    };
  };
}


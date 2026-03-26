{pkgs, ...}: {
  home-manager = import ./home-manager.nix;
  direnv = import ./direnv.nix;
  helix = import ./helix.nix {inherit pkgs;};
  fish = import ./fish.nix {inherit pkgs;};
  tmux = import ./tmux.nix {inherit pkgs;};
}

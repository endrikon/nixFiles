{pkgs, ...}: let
  lib = pkgs.lib;
  utils = import ../../../../utils {inherit lib;};
  recursiveMerge = utils.recursiveMerge;
in
  recursiveMerge [
    (import ./dhall.nix {inherit pkgs;})
    (import ./fsharp.nix {inherit pkgs;})
    (import ./haskell.nix {inherit pkgs;})
    (import ./html.nix {inherit pkgs;})
    (import ./java.nix {inherit pkgs;})
    (import ./nix.nix {inherit pkgs;})
    (import ./python.nix {inherit pkgs;})
    (import ./rust.nix {inherit pkgs;})
    (import ./typescript.nix {inherit pkgs;})
    (import ./go.nix {inherit pkgs;})
  ]

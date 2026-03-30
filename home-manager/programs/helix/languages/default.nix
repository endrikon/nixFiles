{pkgs, ...}: let
  lib = pkgs.lib;
  recursiveMerge = with lib;
    attrList: let
      f = attrPath:
        zipAttrsWith (
          n: values:
            if tail values == []
            then head values
            else if all isList values
            then unique (concatLists values)
            else if all isAttrs values
            then f (attrPath ++ [n]) values
            else last values
        );
    in
      f [] attrList;
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

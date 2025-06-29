{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = with pkgs; [
      (haskellPackages.ghcWithPackages (p:
        [p.cabal-install  p.haskell-language-server]
      ))
      cabal2nix
    ];
    buildInputs = with pkgs; [libpq];
}

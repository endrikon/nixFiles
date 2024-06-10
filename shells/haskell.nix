{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    # nativeBuildInputs is usually what you want -- tools you need to run
    nativeBuildInputs = [ (pkgs.haskellPackages.ghcWithPackages (p: [p.cabal-install  p.haskell-language-server p.OpenGLRaw p.GLURaw p.Agda])) ];
}

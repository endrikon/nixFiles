{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  # nativeBuildInputs is usually what you want -- tools you need to run
  nativeBuildInputs = [
    (pkgs.python3.withPackages (p: [p.numpy p.matplotlib p.pandas]))
    pkgs.ruff
    pkgs.pyright
  ];
}

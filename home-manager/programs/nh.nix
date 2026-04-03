{flake}: {
  inherit flake;
  enable = true;
  clean.enable = true;
  clean.extraArgs = "--keep-since 4d --keep 3";
}

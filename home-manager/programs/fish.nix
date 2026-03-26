{pkgs, ...}: {
  enable = true;
  loginShellInit = "";
  plugins = [
    # Enable a plugin (here grc for colorized command output) from nixpkgs
    {
      name = "grc";
      src = pkgs.fishPlugins.grc.src;
    }
    {
      name = "fzf-fish";
      src = pkgs.fishPlugins.fzf-fish.src;
    }
    {
      name = "bobthefish";
      src = pkgs.fishPlugins.bobthefish.src;
    }
  ];
}

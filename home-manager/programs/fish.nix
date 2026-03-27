{pkgs, ...}: {
  enable = true;
  loginShellInit = "";
  functions = {
    zsh = "ZSH_PLEASE=1 command zsh $argv";
    nix = ''
      if contains -- shell $argv
          command nix $argv --command fish
      else
          command nix $argv
      end
    '';
  };
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

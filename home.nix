{ pkgs, defaultUser ? "endrit", system, gitu, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "${defaultUser}";
  home.homeDirectory = "/home/${defaultUser}";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.packages = [ gitu.packages.${system}.default ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # direnv
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
  };

  programs.helix = {
    enable = true;
    settings = {
      theme = "sonokai";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };

    extraPackages = with pkgs; [ rust-analyzer haskell-language-server ];

    languages = {
      language-server = {
        rust-analyzer = {
          command = "rust-analyzer";
          config.inlayHints = {
            bindingModeHints.enable = false;
            closingBraceHints.minLines = 10;
            discirminantHints.enable = "fieldless";
            lifetimeEisionHInts.enable = "skip_trivial";
            typehints.hideClosureInitialization = false;
          };
        };
        haskell-language-server-wrapper.command = "haskell-language-server";
      };

      language = [
        {
          name = "rust";
          auto-format = false;
        }
        {
          name = "haskell";
          auto-format = false;
        }
      ];
    };
  };

  # zsh
  programs.zsh = {
    enable = true;
    zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
        { name = "jeffreytse/zsh-vi-mode"; }
        { name = "themes/gallois"; tags = [ as:theme from:oh-my-zsh ]; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = [ defer:2 ]; }
      ];
    };
  };
}

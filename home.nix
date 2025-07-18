{
  pkgs,
  defaultUser ? "endrit",
  system,
  gitu,
  ...
}: {
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

  home.packages = [gitu.packages.${system}.default];

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
        end-of-line-diagnostics = "hint";
        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };
        inline-diagnostics = {
          cursor-line = "error";
        };
      };
    };

    extraPackages = with pkgs; [
      rust-analyzer
      rustfmt

      haskell-language-server
      fourmolu

      jdt-language-server

      nil
      alejandra

      dhall-lsp-server
      typescript-language-server
    ];

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
        jdtls.command = "jdtls";
        nil.command = "nil";
        dhall-lsp-server.command = "dhall-lsp-server";
        javascript.command = "typescript-language-server";
      };

      language = [
        {
          name = "rust";
          formatter = {command = "rustfmt";};
          auto-format = true;
        }
        {
          name = "haskell";
          auto-format = true;
          formatter = {
            command = "zsh";
            args = ["-c" "fourmolu --stdin-input-file $(pwd)"];
          };
        }
        {
          name = "java";
          auto-format = true;
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {command = "alejandra";};
        }
        {
          name = "dhall";
          auto-format = true;
        }
        {
          name = "javascript";
          auto-format = true;
        }
      ];
    };
  };

  # zsh
  programs.zsh = {
    enable = true;
    sessionVariables = {
      EDITOR = "hx";
    };
    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";} # Simple plugin installation
        {name = "jeffreytse/zsh-vi-mode";}
        {
          name = "themes/gallois";
          tags = ["as:theme" "from:oh-my-zsh"];
        }
        {
          name = "zsh-users/zsh-syntax-highlighting";
          tags = ["defer:2"];
        }
      ];
    };
  };

  # tmux
  programs.tmux = {
    enable = true;
    clock24 = true;
    disableConfirmationPrompt = true;
    keyMode = "vi";
    terminal = "screen-256color";
    tmuxinator.enable = true;
    newSession = true; # Automatically spawn a session if trying to attach and none are running.
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank
    ];
  };
}

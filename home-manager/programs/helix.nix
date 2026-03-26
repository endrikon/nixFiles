{pkgs, ...}: {
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

    superhtml
    prettierd

    ruff
    pyright

    # Wrapper script to make fantomas work with stdin/stdout
    (pkgs.writeShellScriptBin "fantomas-stdio" ''
      # Create a temporary file
      tmp=$(mktemp --suffix=.fs)

      # Read stdin to temp file
      cat > "$tmp"

      # Format the temp file
      fantomas "$tmp" > /dev/null 2>&1

      # Output the formatted content
      cat "$tmp"

      # Clean up
      rm "$tmp"
    '')
  ];

  languages = {
    language-server = {
      fsautocomplete = {
        command = "fsautocomplete";
        config = {
          AutomaticWorkspaceInit = true;
        };
      };
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
      typescript.command = "typescript-language-server";
      html.command = "superhtml-lsp";
      ruff = {
        command = "ruff";
        args = ["server"];
      };
      pyright = {
        command = "pyright-langserver";
        args = ["--stdio"];
      };
    };

    language = [
      {
        name = "fsharp";
        scope = "source.fs";
        injection-regex = "f(sharp|s)";
        file-types = ["fs" "fsx" "fsi"];
        roots = ["*.fsproj" "*.sln"];
        comment-token = "//";
        indent = {
          tab-width = 4;
          unit = "    ";
        };
        language-servers = ["fsautocomplete"];
        formatter = {
          command = "fantomas-stdio";
        };
        auto-format = false;
      }
      {
        name = "rust";
        formatter = {command = "rustfmt";};
        auto-format = false;
      }
      {
        name = "python";
        language-servers = ["ruff" "pyright"];
        formatter = {
          command = "ruff";
          args = ["format" "-"];
        };
        auto-format = false;
      }
      {
        name = "haskell";
        auto-format = false;
        formatter = {
          command = "zsh";
          args = ["-c" "fourmolu --stdin-input-file $(pwd)"];
        };
      }
      {
        name = "java";
        auto-format = false;
      }
      {
        name = "nix";
        auto-format = false;
        formatter = {command = "alejandra";};
      }
      {
        name = "dhall";
        auto-format = false;
      }
      {
        name = "javascript";
        auto-format = false;
      }
      {
        name = "typescript";
        auto-format = false;
        formatter = {
          command = "prettierd";
          args = [".ts"];
        };
      }
      {
        name = "tsx";
        auto-format = false;
        formatter = {
          command = "prettierd";
          args = [".tsx"];
        };
      }
      {
        name = "html";
        auto-format = false;
        formatter = {
          command = "prettierd";
          args = [".html"];
        };
      }
      {
        name = "css";
        auto-format = false;
        formatter = {
          command = "prettierd";
          args = [".css"];
        };
      }
    ];
  };
}

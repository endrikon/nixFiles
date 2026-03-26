{pkgs, ...}: {
  extraPackages = [
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
    ];

    language-server = {
      fsautocomplete = {
        command = "fsautocomplete";
        config = {
          AutomaticWorkspaceInit = true;
        };
      };
    };
  };
}

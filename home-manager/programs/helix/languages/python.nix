{pkgs, ...}: {
  extraPackages = with pkgs; [
    ruff
    pyright
  ];

  languages = {
    language = [
      {
        name = "python";
        language-servers = ["ruff" "pyright"];
        formatter = {
          command = "ruff";
          args = ["format" "-"];
        };
        auto-format = false;
      }
    ];

    language-server = {
      ruff = {
        command = "ruff";
        args = ["server"];
      };
      pyright = {
        command = "pyright-langserver";
        args = ["--stdio"];
      };
    };
  };
}

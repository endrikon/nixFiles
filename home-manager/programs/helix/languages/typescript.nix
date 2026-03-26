{pkgs, ...}: {
  extraPackages = with pkgs; [
    typescript-language-server
    prettierd
  ];

  languages = {
    language = [
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
    ];

    language-server = {
      javascript.command = "typescript-language-server";
      typescript.command = "typescript-language-server";
    };
  };
}

{pkgs, ...}: {
  extraPackages = with pkgs; [
    superhtml
    prettierd
  ];

  languages = {
    language = [
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

    language-server = {
      html.command = "superhtml-lsp";
    };
  };
}

{pkgs, ...}: {
  extraPackages = with pkgs; [
    dhall-lsp-server
  ];

  languages = {
    language = [
      {
        name = "dhall";
        auto-format = false;
      }
    ];

    language-server = {
      dhall-lsp-server.command = "dhall-lsp-server";
    };
  };
}

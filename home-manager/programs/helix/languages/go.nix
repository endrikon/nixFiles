{pkgs, ...}: {
  extraPackages = with pkgs; [
    gopls
  ];

  languages = {
    language = [
      {
        name = "go";
        auto-format = false;
        language-servers = ["gopls"];
      }
    ];

    language-server = {
      gopls = {
        command = "gopls";
        args = ["-logfile=/tmp/gopls.log" "serve"];
        config = {
          "ui.diagnostic.staticcheck" = true;
          gofumpt = true;
        };
      };
    };
  };
}

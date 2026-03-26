{pkgs, ...}: {
  extraPackages = with pkgs; [
    fourmolu
    haskell-language-server
  ];

  languages = {
    language = [
      {
        name = "haskell";
        auto-format = false;
        formatter = {
          command = "zsh";
          args = ["-c" "fourmolu --stdin-input-file $(pwd)"];
        };
      }
    ];

    language-server = {
      haskell-language-server-wrapper.command = "haskell-language-server";
    };
  };
}

{pkgs, ...}: {
  extraPackages = with pkgs; [
    rust-analyzer
    rustfmt
  ];

  languages = {
    language = [
      {
        name = "rust";
        formatter = {command = "rustfmt";};
        auto-format = false;
      }
    ];

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
    };
  };
}

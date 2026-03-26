{pkgs, ...}: {
  extraPackages = with pkgs; [
    nil
    alejandra
  ];

  languages = {
    language = [
      {
        name = "nix";
        auto-format = false;
        formatter = {command = "alejandra";};
      }
    ];

    language-server = {
      nil.command = "nil";
    };
  };
}

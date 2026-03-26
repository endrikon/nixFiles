{pkgs, ...}: {
  extraPackages = with pkgs; [
    jdt-language-server
  ];

  languages = {
    language = [
      {
        name = "java";
        auto-format = false;
      }
    ];

    language-server = {
      jdtls.command = "jdtls";
    };
  };
}

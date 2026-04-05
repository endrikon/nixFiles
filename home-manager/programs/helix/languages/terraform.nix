{pkgs, ...}: {
  extraPackages = with pkgs; [
    terraform
    terraform-ls
  ];

  languages = {
    language = [
      {
        name = "hcl";
        scope = "source.hcl";
        file-types = [ "hcl" "tf" ];
        auto-format = false;
        formatter = {
          command = "terraform";
          args = ["fmt" "-"];
        };
        language-servers = ["terraform-ls"];
      }
    ];
    language-server.terraform-ls = {
      command = "terraform-ls";
      args = ["serve"];
    };
  };
}

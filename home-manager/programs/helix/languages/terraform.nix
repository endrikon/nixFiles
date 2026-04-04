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
        file-types = [ "hcl" ];
        auto-format = false;
        formatter = {
          command = "terraform";
          args = ["fmt" "-"];
        };
        language-servers = ["terraform-ls"];
      }
      {
        name = "terraform";
        scope = "source.terraform";
        file-types = [ "tf" "tfvars" ];
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

{pkgs, ...}: let
  lib = pkgs.lib;
  utils = import ../../../utils {inherit lib;};
  recursiveMerge = utils.recursiveMerge;
in
  recursiveMerge [
    {
      enable = true;
      settings = {
        theme = "sonokai";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          end-of-line-diagnostics = "hint";
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
          inline-diagnostics = {
            cursor-line = "error";
          };
        };
      };
    }
    (import ./languages {inherit pkgs;})
  ]

{pkgs, ...}: let
  lib = pkgs.lib;
  recursiveMerge = with lib;
    attrList: let
      f = attrPath:
        zipAttrsWith (
          n: values:
            if tail values == []
            then head values
            else if all isList values
            then unique (concatLists values)
            else if all isAttrs values
            then f (attrPath ++ [n]) values
            else last values
        );
    in
      f [] attrList;
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

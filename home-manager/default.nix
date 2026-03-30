{
  pkgs,
  defaultUser ? "endrit",
  system,
  gitu,
  extraHomeManagerConfigs,
  ...
}: let
  lib = pkgs.lib;
  utils = import ../utils {inherit lib;};
  recursiveMerge = utils.recursiveMerge;
in {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${defaultUser} = {pkgs, ...}:
    recursiveMerge [
      {
        # Home Manager needs a bit of information about you and the
        # paths it should manage.
        home.username = "${defaultUser}";
        home.homeDirectory = "/home/${defaultUser}";

        # This value determines the Home Manager release that your
        # configuration is compatible with. This helps avoid breakage
        # when a new Home Manager release introduces backwards
        # incompatible changes.
        #
        # You can update Home Manager without changing this value. See
        # the Home Manager release notes for a list of state version
        # changes in each release.
        home.stateVersion = "22.11";

        home.packages = [
          gitu.packages.${system}.default
          pkgs.grc
        ];

        programs = import ./programs {inherit pkgs;};
      }
      extraHomeManagerConfigs
    ];
}

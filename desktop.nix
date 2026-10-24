{
  lib,
  pkgs,
  ...
}: {
  programs.slock.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  security.pam.services.hyprlock = {};

  services = {
    displayManager.defaultSession = lib.mkForce "hyprland";
    upower.enable = true;
    xserver.displayManager.importedVariables = [
      "XDG_SESSION_TYPE"
      "XDG_CURRENT_DESKTOP"
    ];
    xserver.displayManager.sessionCommands = ''
      if [ "$XDG_SESSION_TYPE" = x11 ]; then
        export WAYLAND_DISPLAY=
        export HYPRLAND_INSTANCE_SIGNATURE=
        ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY HYPRLAND_INSTANCE_SIGNATURE
      fi
    '';
    xserver.displayManager.lightdm.greeters.gtk.indicators = [
      "~host"
      "~spacer"
      "~clock"
      "~spacer"
      "~session"
      "~language"
      "~a11y"
      "~power"
    ];
    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      LidSwitchIgnoreInhibited = "no";
    };
  };

  systemd.user.services.picom.unitConfig.ConditionEnvironment = "XDG_SESSION_TYPE=x11";

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  hardware = {
    sane = {
      enable = lib.mkDefault true; # Scanner support
      extraBackends = [
        pkgs.sane-airscan # Driverless scanning support
      ];
    };
  };

  fonts.packages = with pkgs; [
    inter
    font-awesome
    meslo-lgs-nf
  ];

  environment = {
    systemPackages = with pkgs; [
      # mozilla
      firefox #browser
      thunderbird

      # nitrogen #wallpaper
      dmenu
      xbacklight
      brightnessctl
      redshift

      # sound
      sof-firmware

      # files
      evince # pdf viewer
      nomacs # image viewer
      thunar

      # fonts and themes
      lxappearance # theme setter for gtk applications
      #libsForQt5.qt5ct # theme setter for qt applications

      # latex and texts
      libreoffice-qt
      hunspell
      hunspellDicts.de_CH
      hunspellDicts.en-gb-ize
    ];
  };
}

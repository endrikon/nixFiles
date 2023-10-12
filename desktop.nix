{ config, lib, pkgs, defaultUser ? "endrit", ... }:

{
 systemd.services.slock-sleep = {
    enable = true;
    description = "Lock X session using slock on sleep";
    before = ["sleep.target"];
    wantedBy = ["sleep.target"];
    serviceConfig.PassEnvironment = "DISPLAY";
    script = "${pkgs.slock}/bin/slock";
  };

  hardware = {
    sane = {
      enable = lib.mkDefault true; # Scanner support
      extraBackends = [
        pkgs.sane-airscan # Driverless scanning support
      ];
    };
  };

  fonts.fonts = with pkgs; [
    font-awesome
    meslo-lgs-nf
  ];

  environment = {
    systemPackages = with pkgs;
      [
        # mozilla
        firefox #browser
        thunderbird

        nitrogen #wallpaper
        dmenu
        xorg.xbacklight
        brightnessctl
        redshift

        # sound
        sof-firmware

        # files
        evince # pdf viewer
        nomacs # image viewer
        xfce.thunar

        # fonts and themes
        lxappearance # theme setter for gtk applications
        #libsForQt5.qt5ct # theme setter for qt applications

        # latex and texts
        libreoffice-qt
        hunspell
        hunspellDicts.de_CH
        hunspellDicts.en-gb-ize
        texlive.combined.scheme-full
      ];
  };
}

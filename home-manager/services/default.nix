{pkgs}: {
  xidlehook = {
    enable = true;
    not-when-audio = true;
    not-when-fullscreen = true;
    timers = [
      {
        delay = 600; # 10 min
        command = "/run/wrappers/bin/slock";
      }
    ];
  };
  screen-locker = {
    enable = true;
    lockCmd = "/run/wrappers/bin/slock";
  };
}

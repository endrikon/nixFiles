{pkgs}: {
  screen-locker = {
    enable = true;
    lockCmd = "/run/wrappers/bin/slock";
    inactiveInterval = 10;
  };
}

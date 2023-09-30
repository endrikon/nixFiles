{ config, lib, pkgs, defaultUser ? "endrit", ... }:

{

  boot = {
    loader = {
      systemd-boot.enable = lib.mkDefault true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };

  # Enable networking
  networking = {
    networkmanager.enable = lib.mkDefault true;
    wireless.enable = lib.mkDefault false; # Disable wireless support via wpa_supplicant.
    firewall = {
      enable = lib.mkDefault true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Configure keymap in X11
  services = {
    xserver = {
      layout = "ch";
      xkbVariant = "de_nodeadkeys";
      libinput.enable = true;
      libinput.touchpad.naturalScrolling = true;
      libinput.touchpad.middleEmulation = true;
      libinput.touchpad.tapping = true;
    };

    printing.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };

    # Audio
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  # Audio
  security.rtkit.enable = true;


  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # shell
  programs.zsh.enable = true;

  # Configure console keymap
  console.keyMap = "sg";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users."${defaultUser}" = {
      isNormalUser = true;
      description = "User";
      extraGroups = [ "networkmanager" "wheel" "audio" "sound" "video" "input" "tty"];
      packages = with pkgs; [];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # editors
    vim
    emacs

    # terminals and terminal commands
    alacritty #terminal emulator
    pciutils
    zsh
    ranger
    w3m

    # audio
    alsa-utils
    pulseaudio
    pavucontrol

    # bluetooth
    bluez
    blueman

    # power management
    tlp

    # Python
    (python3.withPackages(ps: with ps;
     [ pandas numpy matplotlib requests ipython ]))


    # home-manager
    home-manager

    htop
    wget
    git
  ];
}

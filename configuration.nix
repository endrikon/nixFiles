# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    layout = "ch";
    xkbVariant = "de_nodeadkeys";
    libinput.enable = true;
    libinput.touchpad.naturalScrolling = true;
    libinput.touchpad.middleEmulation = true;
    libinput.touchpad.tapping = true;
  };

  # enable flakes
  # nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  # enable printing
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # xmonad
  #services.xserver.enable = true;
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.windowManager = {
  #  xmonad.enable = true;
  #  xmonad.enableContribAndExtras = true;
  #  xmonad.extraPackages = hpkgs: [
  #    hpkgs.xmonad
  #    hpkgs.xmonad-contrib
  #    hpkgs.xmonad-extras
  #    hpkgs.xmobar
  #  ];
  #};

  #services.picom.enable = true;
  #services.xserver.windowManager.xmonad.config = builtins.readFile /home/endrit/.xmonad/xmonad.hs;

  # Audio
  #sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  #hardware.pulseaudio.enable = true;  

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # thunar plugins
  programs.thunar.plugins = with pkgs.xfce; [ thunar-volman ];

  # fonts
  fonts.fonts = with pkgs; [
    font-awesome
    meslo-lgs-nf
  ];

  # Configure console keymap
  console.keyMap = "sg";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.endrit = {
    isNormalUser = true;
    description = "Endrit";
    extraGroups = [ "networkmanager" "wheel" "audio" "sound" "video" "input" "tty"];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget

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

    # mozilla
    firefox #browser
    thunderbird
    
    nitrogen #wallpaper
    dmenu
    xorg.xbacklight
    brightnessctl
    redshift
    
    # audio
    alsa-utils
    pulseaudio
    pavucontrol

    # bluetooth
    bluez
    blueman 
    
    # files
    evince # pdf viewer
    nomacs # image viewer
    xfce.thunar

    # power management
    tlp

    # xmonad
    #haskellPackages.xmobar

    # fonts and themes
    lxappearance # theme setter for gtk applications
    #libsForQt5.qt5ct # theme setter for qt applications

    # Python
    (python3.withPackages(ps: with ps;
     [ pandas numpy matplotlib requests ipython ]))

    # latex and texts
    libreoffice-qt
    hunspell
    hunspellDicts.de_CH
    hunspellDicts.en-gb-ize
    texlive.combined.scheme-full

    # home-manager
    home-manager

    htop
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}

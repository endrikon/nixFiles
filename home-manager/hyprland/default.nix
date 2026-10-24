{
  lib,
  pkgs,
  ...
}: let
  monitorRules = [
    {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = "auto";
    }
    {
      output = "desc:Samsung Electric Company LS32A70";
      mode = "preferred";
      position = "auto";
      scale = 2;
    }
  ];
  commands = {
    terminal = "${pkgs.alacritty}/bin/alacritty";
    launcher = "${pkgs.wofi}/bin/wofi --show drun";
    run = "${pkgs.wofi}/bin/wofi --show run";
    browser = "${pkgs.firefox}/bin/firefox";
    lock = "${pkgs.procps}/bin/pgrep -x hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
    reload = "${pkgs.hyprland}/bin/hyprctl reload";
    volumeUp = "${pkgs.alsa-utils}/bin/amixer -q set Master 4%+ unmute";
    volumeDown = "${pkgs.alsa-utils}/bin/amixer -q set Master 4%- unmute";
    volumeMute = "${pkgs.alsa-utils}/bin/amixer -q set Master toggle";
    brightnessUp = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
    brightnessDown = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
    help = "${pkgs.alacritty}/bin/alacritty -e ${pkgs.less}/bin/less ${../../docs/desktop-sessions.md}";
  };
in {
  imports = [./bar.nix];

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    configType = "lua";
    systemd.enable = true;
    settings = {
      monitor = monitorRules;
      curve._args = [
        "smoothWindow"
        {
          type = "bezier";
          points = [[0.16 1] [0.3 1]];
        }
      ];
      animation = [
        {
          leaf = "global";
          enabled = false;
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 2.2;
          bezier = "smoothWindow";
          style = "popin 96%";
        }
        {
          leaf = "windowsMove";
          enabled = true;
          speed = 2.2;
          bezier = "smoothWindow";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 1.6;
          bezier = "smoothWindow";
        }
      ];
      config = {
        general = {
          layout = "master";
          border_size = 2;
          gaps_in = 3;
          gaps_out = 3;
          col = {
            active_border = "rgb(4d9ab2)";
            inactive_border = "rgb(dddddd)";
          };
        };
        master = {
          mfact = 0.5;
          orientation = "left";
          new_status = "master";
          allow_small_split = true;
        };
        input = {
          kb_layout = "ch";
          kb_variant = "de_nodeadkeys";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            middle_button_emulation = true;
            tap_to_click = true;
          };
        };
        decoration = {
          rounding = 6;
          shadow.enabled = false;
          blur.enabled = false;
        };
        animations.enabled = true;
        misc.disable_hyprland_logo = true;
      };
      window_rule = {
        match.class = "^(MPlayer|Gimp|gimp.*)$";
        float = true;
      };
    };
    extraConfig = ''
      local commands = ${lib.generators.toLua {} commands}
      local monitorControls = (function()
        ${builtins.readFile ./monitor-controls.lua}
      end)()
      ${builtins.readFile ./bindings.lua}
    '';
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      background = [{color = "rgb(2b2b2b)";}];
      input-field = [
        {
          size = "300, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          outer_color = "rgb(4d9ab2)";
          inner_color = "rgb(2b2b2b)";
          font_color = "rgb(ffffff)";
          placeholder_text = "Password...";
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    settings = {
      general = {
        lock_cmd = commands.lock;
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
      ];
    };
  };

  systemd.user.services = {
    xidlehook.Unit.ConditionEnvironment = lib.mkForce ["XDG_SESSION_TYPE=x11"];
    xss-lock.Unit.ConditionEnvironment = ["XDG_SESSION_TYPE=x11"];
    xautolock-session.Unit.ConditionEnvironment = ["XDG_SESSION_TYPE=x11"];
    hyprsunset = {
      Unit = {
        Description = "Warm screen colors for Hyprland";
        PartOf = ["hyprland-session.target"];
        After = ["hyprland-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset --temperature 4000";
        Restart = "on-failure";
      };
      Install.WantedBy = ["hyprland-session.target"];
    };
  };
}

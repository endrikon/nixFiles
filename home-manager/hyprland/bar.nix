{pkgs, ...}: {
  wayland.systemd.target = "hyprland-session.target";

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      shell = {
        font_family = "Inter";
        time_format = "{:%H:%M}";
        clipboard_enabled = false;
        launcher.fetch_exchange_rates = false;
        session.actions = [
          {
            action = "lock";
            command = "${pkgs.systemd}/bin/loginctl lock-session";
          }
          {action = "suspend";}
          {
            action = "command";
            label = "Hibernate";
            command = "${pkgs.systemd}/bin/systemctl hibernate";
          }
          {action = "reboot";}
          {
            action = "logout";
            command = "${pkgs.hyprland}/bin/hyprctl dispatch 'hl.dsp.exit()'";
          }
          {action = "shutdown";}
        ];
      };
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
        sync_color_scheme = false;
        templates = {
          enable_builtin_templates = false;
          enable_community_templates = false;
        };
      };
      bar.main = {
        position = "top";
        thickness = 36;
        margin_ends = 10;
        margin_edge = 8;
        padding = 10;
        radius = 14;
        background_opacity = 0.95;
        compositor_blur = false;
        reserve_space = true;
        capsule = true;
        capsule_fill = "surface_variant";
        start = ["control-center" "workspaces" "active_window"];
        center = ["clock"];
        end = ["tray" "network" "volume" "brightness" "battery" "session"];
      };
      widget = {
        "control-center" = {
          type = "control-center";
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          custom_image_colorize = false;
        };
        active_window = {
          type = "active_window";
          max_length = 160;
        };
        clock = {
          type = "clock";
          format = "{:%a %d %b  %H:%M}";
        };
      };
      notification.enable_daemon = false;
      idle.behavior = {
        lock.enabled = false;
        screen-off.enabled = false;
      };
      wallpaper.enabled = false;
      dock.enabled = false;
      nightlight.enabled = false;
      weather.enabled = false;
    };
  };
}

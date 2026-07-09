{
  enable = true;
  settings = {
    global = {
      # Show on the monitor with keyboard focus. The default (monitor = 0,
      # follow = none) pins every notification to the primary monitor.
      follow = "keyboard";
      origin = "top-right";
      width = 380;
      height = 160;
      offset = "20x40";
      frame_width = 2;
      frame_color = "#555555";
      separator_color = "frame";
      corner_radius = 8;
      padding = 12;
      horizontal_padding = 14;
      font = "MesloLGS NF 10";
    };
    urgency_low = {
      background = "#2b2b2b";
      foreground = "#ffffff";
    };
    urgency_normal = {
      background = "#2b2b2b";
      foreground = "#ffffff";
    };
    urgency_critical = {
      background = "#2b2b2b";
      foreground = "#ffffff";
      frame_color = "#ff5555";
    };
  };
}

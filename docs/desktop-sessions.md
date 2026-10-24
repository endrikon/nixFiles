# XMonad and Hyprland sessions

Both `laptop` and `lenovo` offer XMonad (X11) and Hyprland (Wayland) in
LightDM's session menu, in the top panel. Choose the session before logging in.
Hyprland is the default; XMonad remains available in the session menu.
To change sessions later, log out with **Super+Shift+Q** and select the other
session at the login screen. Switching ends applications in the current session.

Apply the configuration with the appropriate host name:

```sh
sudo nixos-rebuild switch --flake path:/home/endrit/nixFiles#lenovo
```

Use `#laptop` for the other configuration. The `path:` flake reference includes
new files before they are tracked by Git. Reboot after the first rebuild to
refresh the login screen and session services.

Hyprland is configured by Home Manager in `home-manager/hyprland/`, targeting
the Lua API in the locked Hyprland 0.56.2. It uses the same Swiss German
keyboard layout (`ch`, `de_nodeadkeys`), focus-follows-mouse, borders, small
gaps, and 50% master split as XMonad.

Windows have subtly rounded corners (6 logical pixels) and a small gap
(3 logical pixels per window edge). New windows gently fade and grow from 96%
size, while existing windows smoothly adjust to the new layout. Workspace and
layer animations remain disabled. Adjust these settings in
`home-manager/hyprland/default.nix`.

## Monitors and bar

Every monitor independently uses its EDID/preferred resolution and refresh rate.
Scaling is automatic except for the Samsung LS32A70, which uses 200% scaling
for readable text at 4K. Hyprland's automatic scaling selects 100% for this
32-inch display. Per-monitor rules live in `home-manager/hyprland/default.nix`.
There is no fixed resolution or shared scaling factor. Newly connected displays
are enabled at their own preferred mode and placed beside the existing screens. Super+Shift+M
places a connected HDMI display above the internal screen while keeping its
current resolution, refresh rate and scaling. Move the pointer up
from the laptop to reach the external screen, and down to return. Without that
shortcut, newly connected displays default to the right: exit the laptop's
right edge and enter the external screen's left edge. Disconnecting a display
moves its workspaces to the remaining screens.

Use **Super+Ctrl+Up** to increase scaling on the focused monitor, or
**Super+Ctrl+Down** to decrease it. Focus follows the mouse, so point at the
screen you want to adjust first. Scaling steps by 25 percentage points between
100% and 300%, skipping factors that cannot produce whole logical pixels for
the current resolution. For example, 4K moves between 150%, 200%, 250% and 300%
because 175%, 225% and 275% do not divide both dimensions cleanly. Other
monitors keep their own scaling; screens to the right or below move with the
changed screen edge to avoid creating gaps or overlaps. The HDMI positioning
shortcut preserves the current scale. Changes last until the configuration is
reloaded or the session ends; Nix monitor rules set the startup defaults.

The bar uses native Noctalia 5.3.0, configured in
`home-manager/hyprland/bar.nix`. It has a floating, rounded Catppuccin dark style,
Inter text, workspace buttons, the active window, a clock/calendar, a system
tray, and network, sound, brightness, battery, and session controls. It appears
on every connected display and follows monitor hotplug and scaling. Click the
control center icon for audio, network, Bluetooth and system controls;
right-click the bar for more controls.

The Quickshell-based Noctalia 4 package fails to compile against the pinned Qt
version, and the standard Quickshell runtime lacks a required Noctalia audio
component. The native package avoids these incompatibilities. Its settings are
validated during the Nix build. The shell's dock, wallpaper manager, notification
daemon, idle actions and night light are disabled. Dunst, Hyprlock/Hypridle and
Hyprsunset continue to provide those session services. Edit `bar.nix` and rebuild
to change the defaults; the Noctalia settings UI can also override them at
runtime. Restart just the bar with:

```sh
systemctl --user restart noctalia.service
```

## Shortcuts

**Super** is the Windows/logo key, matching `mod4Mask` in your actual
`/home/endrit/.xmonad/xmonadrc/xmonad.hs` bindings. The help string in that
XMonad file is outdated; these mappings follow its executable bindings.

| Shortcut | Effect in Hyprland |
| --- | --- |
| Super+Shift+Enter | Open Alacritty |
| Super+D | Application launcher (Wofi, replacing dmenu) |
| Super+Shift+P | Command prompt (Wofi run, replacing gmrun) |
| Super+F | Open Firefox |
| Super+Shift+C | Close the focused window |
| Super+Space | Cycle Tall → Mirror Tall → Full (master left → master top → monocle) |
| Super+Shift+Space | Reset the current workspace to Tall, one master, 50% split |
| Super+N | Recalculate the current layout |
| Super+Tab / Super+J / Super+K | Focus next / next / previous window |
| Super+M | Focus master |
| Super+Enter | Promote the focused tiled window to master |
| Super+Shift+J / K | Swap with the next / previous window |
| Super+H / L | Shrink / grow the master area by 3% |
| Super+T | Return the focused floating window to tiling |
| Super+comma / period | Add / remove a master window |
| Super+1…9 | Show workspace on the current monitor (swap visible workspaces between monitors) |
| Super+Shift+1…9 | Send window to workspace, keeping the current workspace selected |
| Super+W / E / R | Focus monitor 1 / 2 / 3, ordered by Hyprland monitor ID |
| Super+Shift+W / E / R | Send window to that monitor's current workspace, keeping focus here |
| Super+Shift+M | Place the connected HDMI monitor above the internal eDP monitor |
| Super+Ctrl+Up / Down | Increase / decrease scaling on the focused monitor |
| Super+Ctrl+L | Lock (Hyprlock, replacing slock) |
| Super+Q | Reload the Hyprland configuration |
| Super+Shift+Q | Log out to LightDM |
| Super+Shift+slash | Open this shortcut reference |
| Volume keys | Change volume by 4% / toggle mute, matching XMonad |
| Brightness keys | Change brightness by 5%, matching XMonad |
| Super+left drag | Float and move the window |
| Super+middle click | Promote the focused tiled window to master |
| Super+right drag | Float and resize the window |

## Session services and differences

Hyprland uses Noctalia in place of Xmobar and Hyprsunset at 4000 K in place of
Redshift. Dunst serves both sessions. Hypridle locks after 10 minutes and before
sleep, respecting application idle inhibitors. The X11 slock services only run
in X11 sessions; Hyprlock handles locking in Hyprland.

Hyprland's native layouts approximate XMonad's layout state rather than sharing
it. Entering/leaving Full recreates the master layout, resetting its ratio and
master count. Master-specific actions apply in Tall and Mirror Tall. Hyprland
keeps at least one master; XMonad can decrease that count to zero. Floating
windows have a separate stacking order, so focus and mouse promotion may differ.
The HDMI shortcut operates on connected, enabled outputs; Hyprland automatically
enables newly connected monitors. X11-only tools such as xrandr, slock, Picom,
and Nitrogen do not configure the Wayland desktop.

The local `.xmonad` repository supplies the shortcut reference. The XMonad
session itself still comes from the existing pinned `xmonad-session` input.

API reference: [Hyprland Lua configuration](https://wiki.hypr.land/0.56.0/Configuring/Start/)
and [master layout](https://wiki.hypr.land/0.56.0/Configuring/Layouts/Master-Layout/).

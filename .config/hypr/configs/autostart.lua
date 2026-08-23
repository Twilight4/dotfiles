-- autostart.lua (was autostart.conf)
-- MIGRATION: exec-once=CMD  ->  hl.exec_cmd("CMD") inside the start event.
-- hl.exec_cmd is async, so `& disown` is no longer needed.
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME")
    hl.exec_cmd("uwsm app -- udiskie")
    hl.exec_cmd("uwsm app -- swaync")
    hl.exec_cmd("uwsm app -- hyprsunset --gamma_max 150 -g 100 -t 6500")
    hl.exec_cmd("hyprctl hyprsunset identity")
    -- Key remapper (Emacs-style binds, scoped to Zen)
    hl.exec_cmd('uwsm app -d "Xremap key remapper" -- xremap ~/.config/xremap/config.yml --watch=config,device')
    -- Polkit agent
    hl.exec_cmd('uwsm app -d "Polkit authentication agent" -- ~/.config/hypr/scripts/polkit')
    -- Cursor theme
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")
    -- Apps
    hl.exec_cmd('uwsm app -d "Emacs server" -- emacs --daemon')
    hl.exec_cmd("uwsm app -- udev-block-notify")
    hl.exec_cmd('uwsm app -d "Notify log" -- ~/.config/.local/bin/notify-log.sh /tmp/notify.log')
    hl.exec_cmd("uwsm app -- nm-applet --indicator")
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("~/.config/hypr/ws-scripts/ws-emacs")
    hl.exec_cmd("~/.config/hypr/ws-scripts/ws-zen")
    hl.exec_cmd("uwsm app -- freetube --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto --enable-features=VaapiVideoDecodeLinuxGL --gpu-context=wayland")
    -- Music workspace (ws5): cliamp TUI with Mixed playlist playing at -20 dB, fullscreen visualizer
    hl.exec_cmd("uwsm app -- kitty --class kitty-cliamp -e cliamp --vol -20 --playlist Mixed --auto-play")
    hl.exec_cmd([[sleep 2 && hyprctl dispatch 'hl.dsp.focus({window="class:^(kitty-cliamp)$"})' && sleep 0.5 && wtype V && sleep 0.3 && hyprctl dispatch 'hl.dsp.focus({workspace=1})']])
    hl.exec_cmd("uwsm app -- ferdium --socket=wayland --ozone-platform-hint=auto --ozone-platform=wayland --enable-features-WaylandWindowDecorations")
    -- Bluetooth fix
    hl.exec_cmd("rfkill block bluetooth && rfkill unblock bluetooth")
    hl.exec_cmd("uwsm app -- blueman-applet")
    -- Wallpaper + waybar with pywal colors
    hl.exec_cmd("~/.config/hypr/scripts/wallpaper init")
    hl.exec_cmd("sleep 2 && killall -SIGUSR1 waybar")
    -- Land on workspace 1 (Emacs)
    hl.exec_cmd("sleep 2 && hyprctl dispatch 'hl.dsp.focus({workspace=1})'")
    -- Cliphist clipboard manager
    hl.exec_cmd('uwsm app -a cliphist -- wl-paste -n --type text --watch cliphist store')
    hl.exec_cmd('uwsm app -a cliphist -- wl-paste -n --type image --watch cliphist store')
    -- Scripts
    hl.exec_cmd("~/.config/hypr/scripts/gtkthemes")
    hl.exec_cmd("~/.config/hypr/scripts/launch-portals")
end)

-- keybinds.lua (was keybinds.conf)
-- MIGRATION: bind = MOD,key,disp,arg  ->  hl.bind("MOD + key", hl.dsp.<disp>(<arg>))
--   bindl  -> {locked=true}    bindle -> {locked=true, repeating=true}
--   binde  -> {repeating=true} bindm  -> {mouse=true}
local SUPER = "SUPER"

-- WM Operations
hl.bind(SUPER .. " + Return", hl.dsp.exec_cmd("uwsm app -- kitty"))
hl.bind(SUPER .. " + Q", hl.dsp.window.close())                       -- killactive
hl.bind(SUPER .. " + F", hl.dsp.window.fullscreen())                  -- fullscreen
hl.bind(SUPER .. " + T", hl.dsp.window.float({ action = "toggle" }))  -- togglefloating
-- SUPER+SHIFT+T (allfloat) dropped: workspaceopt allfloat has no Lua-era dispatcher
hl.bind(SUPER .. " + SHIFT + S", hl.dsp.window.center())             -- centerwindow
hl.bind("CTRL + ALT + End", hl.dsp.exec_cmd("uwsm app -- kitty -1 --class kitty-sync -T kitty-sync --session ~/.config/kitty/session-sync"))
hl.bind(SUPER .. " + CTRL + End", hl.dsp.exec_cmd("sudo poweroff"))
hl.bind(SUPER .. " + CTRL + Delete", hl.dsp.exec_cmd("uwsm stop"))

-- Plugins
hl.bind(SUPER .. " + grave", function() if hl.plugin.hyprexpo ~= nil then hl.plugin.hyprexpo.expo() end end)  -- hyprexpo+ (sandwich) plugin call

-- Session
hl.bind(SUPER .. " + Y",          hl.dsp.exec_cmd("hyprlock"))
hl.bind(SUPER .. " + SHIFT + Y",  hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprlock-dpms-off"))
hl.bind(SUPER .. " + CTRL + Y",   hl.dsp.exec_cmd("~/.config/hypr/scripts/hypridle-script"))
hl.bind(SUPER .. " + Backspace",  hl.dsp.exec_cmd("pkill wlogout || wlogout"))

-- Rofi / menus
hl.bind(SUPER .. " + R", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -config ~/.config/rofi/configs/config.rasi"))
hl.bind(SUPER .. " + X", hl.dsp.exec_cmd("pkill rofi || ~/.config/rofi/bin/keybinds.sh"))
hl.bind(SUPER .. " + Z", hl.dsp.exec_cmd("pkill wofi || ~/.config/rofi/bin/wofi-beats.sh"))
hl.bind(SUPER .. " + C", hl.dsp.exec_cmd("pkill rofi || ~/.config/rofi/bin/cliphist.sh"))
hl.bind(SUPER .. " + A", hl.dsp.exec_cmd("pkill rofi || ~/.config/rofi/bin/quicklinks.sh"))

-- Toolbars / dock / waybar
hl.bind(SUPER .. " + S",        hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind("CTRL + SPACE",         hl.dsp.exec_cmd("swaync-client --hide-latest"))
hl.bind(SUPER .. " + CTRL + D", hl.dsp.exec_cmd("~/.config/hypr/scripts/dnd-toggle"))
hl.bind(SUPER .. " + CTRL + M", hl.dsp.exec_cmd("~/.config/hypr/scripts/monitor-toggle"))
hl.bind(SUPER .. " + CTRL + C", hl.dsp.exec_cmd('swaync-client -C && notify-send -u low -t 1000 -i "$HOME/.config/mako/icons/silent.png" "Notifications cleared" && sleep 1.2 && swaync-client -C'))
hl.bind(SUPER .. " + D",        hl.dsp.exec_cmd("~/.config/hypr/scripts/dock-toggle-hyprland"))
hl.bind(SUPER .. " + CTRL + T", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(SUPER .. " + CTRL + X", hl.dsp.exec_cmd('hyprpicker -a && notify-send --icon ~/.config/mako/icons/dropper.png -t 4000 "$(wl-paste)"'))

-- Terminal-window scripts
hl.bind(SUPER .. " + CTRL + A",        hl.dsp.exec_cmd("~/.config/hypr/scripts/tm-webcam.sh"))
hl.bind(SUPER .. " + CTRL + SHIFT + A",hl.dsp.exec_cmd("~/.config/hypr/scripts/tm-open-all.sh"))

-- Night light / wallpaper / tools
hl.bind(SUPER .. " + backslash", hl.dsp.exec_cmd("~/.config/hypr/scripts/blue-light-toggle"))
hl.bind(SUPER .. " + ALT + B",   hl.dsp.exec_cmd("~/.config/hypr/scripts/wallpaper select"))
hl.bind(SUPER .. " + ALT + R",   hl.dsp.exec_cmd("~/.config/hypr/scripts/record-screen"))
hl.bind(SUPER .. " + ALT + Z",   hl.dsp.exec_cmd("~/.config/hypr/scripts/cursor-zoom"))
hl.bind(SUPER .. " + ALT + M",   hl.dsp.exec_cmd('notify-send -u normal -t 5000 "$(newsboat -x reload)"'))
hl.bind(SUPER .. " + ALT + F12", hl.dsp.exec_cmd('notify-send "Test notification" "$(hyprctl version | head -1)"'))
hl.bind(SUPER .. " + ALT + T",   hl.dsp.exec_cmd("~/.config/hypr/scripts/gamemode"))
hl.bind(SUPER .. " + CTRL + E",  hl.dsp.exec_cmd("uwsm app -- emote"))

-- Screenshots
hl.bind("Print",                   hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --area"))
hl.bind("SHIFT + Print",           hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --area-edit"))
hl.bind("ALT + Print",             hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --area-save"))
hl.bind(SUPER .. " + Print",       hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --win"))
hl.bind(SUPER .. " + SHIFT + Print", hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --win-edit"))
hl.bind(SUPER .. " + ALT + Print",   hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --win-save"))
hl.bind("CTRL + Print",            hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --full"))
hl.bind("CTRL + SHIFT + Print",    hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --full-edit"))
hl.bind("CTRL + ALT + Print",      hl.dsp.exec_cmd("~/.config/hypr/scripts/screenshot --full-save"))

-- Volume (was bindle -> locked+repeating)
hl.bind("XF86audioraisevolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume --inc"), { locked = true, repeating = true })
hl.bind("XF86audiolowervolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume --dec"), { locked = true, repeating = true })
hl.bind("XF86audiomute",        hl.dsp.exec_cmd("~/.config/hypr/scripts/volume --toggle"), { locked = true })

-- Brightness (was bindle)
hl.bind("XF86monbrightnessup",   hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprsunset-gamma --inc"), { locked = true, repeating = true })
hl.bind("XF86monbrightnessdown", hl.dsp.exec_cmd("~/.config/hypr/scripts/hyprsunset-gamma --dec"), { locked = true, repeating = true })

-- Audio (was bindl -> locked)
hl.bind("xf86AudioPause",     hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --pause"), { locked = true })
hl.bind("xf86AudioPlay",      hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --pause && ~/.config/zsh/bash-scripts/now-playing"), { locked = true })
hl.bind("xf86AudioNext",      hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --nxt"), { locked = true })
hl.bind("xf86AudioPrev",      hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --prv"), { locked = true })
hl.bind("xf86audiostop",      hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --stop"), { locked = true })

-- Audio on second keyboard (bindl)
hl.bind("ALT + F1", hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --pause"), { locked = true })
hl.bind("ALT + F2", hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --nxt"),   { locked = true })
hl.bind("ALT + F3", hl.dsp.exec_cmd("~/.config/hypr/scripts/audio --prv"),   { locked = true })

-- Calc key
hl.bind("XF86Calculator", hl.dsp.exec_cmd("~/.config/hypr/ws-scripts/ws-calc"))

-- WM focus / master layout
hl.bind(SUPER .. " + Tab",       hl.dsp.focus({ monitor = "+1" }))                       -- focusmonitor
hl.bind(SUPER .. " + ALT + Tab", hl.dsp.workspace.move({ monitor = "+1" }))              -- movecurrentworkspacetomonitor
hl.bind(SUPER .. " + SHIFT + Tab", hl.dsp.workspace.swap_monitors({ monitor1 = "DP-1", monitor2 = "HDMI-A-1" }))

hl.bind(SUPER .. " + J", hl.dsp.layout("cyclenext"))
hl.bind(SUPER .. " + K", hl.dsp.layout("cycleprev"))
hl.bind(SUPER .. " + CTRL + K", hl.dsp.layout("addmaster"))
hl.bind(SUPER .. " + CTRL + J", hl.dsp.layout("removemaster"))
hl.bind(SUPER .. " + SHIFT + J", hl.dsp.layout("swapnext"))
hl.bind(SUPER .. " + SHIFT + K", hl.dsp.layout("swapprev"))

-- Floating focus cycle (two dispatchers on one key -> one function)
hl.bind("ALT + Tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Resize (was binde -> repeating)
hl.bind(SUPER .. " + ALT + H", hl.dsp.window.resize({ x = -60, y = 0,  relative = true }), { repeating = true })
hl.bind(SUPER .. " + ALT + J", hl.dsp.window.resize({ x = 0,  y = 60,  relative = true }), { repeating = true })
hl.bind(SUPER .. " + ALT + K", hl.dsp.window.resize({ x = 0,  y = -60, relative = true }), { repeating = true })
hl.bind(SUPER .. " + ALT + L", hl.dsp.window.resize({ x = 60, y = 0,  relative = true }), { repeating = true })

-- Workspaces
hl.bind(SUPER .. " + I", hl.dsp.focus({ workspace = 1 }))
hl.bind(SUPER .. " + W", hl.dsp.focus({ workspace = 2 }))
hl.bind(SUPER .. " + O", hl.dsp.focus({ workspace = 3 }))
hl.bind(SUPER .. " + U", hl.dsp.focus({ workspace = 4 }))
hl.bind(SUPER .. " + P", hl.dsp.focus({ workspace = 5 }))
hl.bind(SUPER .. " + E", hl.dsp.focus({ workspace = 6 }))

-- Apps on workspaces
hl.bind(SUPER .. " + CTRL + I", hl.dsp.exec_cmd("~/.config/hypr/ws-scripts/ws-emacs"))
hl.bind(SUPER .. " + CTRL + W", hl.dsp.exec_cmd("~/.config/hypr/ws-scripts/ws-zen"))
hl.bind(SUPER .. " + CTRL + U", hl.dsp.exec_cmd("~/.config/hypr/ws-scripts/ws-freetube"))
hl.bind(SUPER .. " + CTRL + O", hl.dsp.exec_cmd("~/.config/hypr/ws-scripts/ws-ferdium"))
hl.bind(SUPER .. " + CTRL + P", hl.dsp.exec_cmd("~/.config/hypr/ws-scripts/ws-cliamp"))
hl.bind(SUPER .. " + CTRL + N", hl.dsp.exec_cmd('bash -c "uwsm app -- gnome-clocks & uwsm app -- gnome-weather & uwsm app -- gnome-calculator &"'))

-- Move window to a workspace
hl.bind(SUPER .. " + SHIFT + I", hl.dsp.window.move({ workspace = 1 }))
hl.bind(SUPER .. " + SHIFT + W", hl.dsp.window.move({ workspace = 2 }))
hl.bind(SUPER .. " + SHIFT + O", hl.dsp.window.move({ workspace = 3 }))
hl.bind(SUPER .. " + SHIFT + U", hl.dsp.window.move({ workspace = 4 }))
hl.bind(SUPER .. " + SHIFT + P", hl.dsp.window.move({ workspace = 5 }))
hl.bind(SUPER .. " + SHIFT + E", hl.dsp.window.move({ workspace = 6 }))

-- Silently move window to a workspace (movetoworkspacesilent -> follow=false)
hl.bind(SUPER .. " + ALT + I", hl.dsp.window.move({ workspace = 1, follow = false }))
hl.bind(SUPER .. " + ALT + W", hl.dsp.window.move({ workspace = 2, follow = false }))
hl.bind(SUPER .. " + ALT + O", hl.dsp.window.move({ workspace = 3, follow = false }))
hl.bind(SUPER .. " + ALT + U", hl.dsp.window.move({ workspace = 4, follow = false }))
hl.bind(SUPER .. " + ALT + P", hl.dsp.window.move({ workspace = 5, follow = false }))
hl.bind(SUPER .. " + ALT + E", hl.dsp.window.move({ workspace = 6, follow = false }))

-- Toggle special workspace
hl.bind(SUPER .. " + L",      hl.dsp.workspace.toggle_special("other"))
hl.bind(SUPER .. " + Comma",  hl.dsp.workspace.toggle_special("scratchpad"))
hl.bind(SUPER .. " + M",      hl.dsp.workspace.toggle_special("comma"))
hl.bind(SUPER .. " + N",      hl.dsp.workspace.toggle_special("floating"))

-- The five stacked `bind = SUPER, H, ...` lines were a hack to move the active
-- window into special:magic while toggling it on/off. In Lua one key -> one
-- function with ordered dispatches.
hl.bind(SUPER .. " + H", function()
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "+0" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
    hl.dispatch(hl.dsp.window.move({ workspace = "special:magic" }))
    hl.dispatch(hl.dsp.workspace.toggle_special("magic"))
end)

-- Move window to special workspace
hl.bind(SUPER .. " + SHIFT + L",      hl.dsp.window.move({ workspace = "special:other",      follow = false }))
hl.bind(SUPER .. " + SHIFT + Comma",  hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
hl.bind(SUPER .. " + SHIFT + M",      hl.dsp.window.move({ workspace = "special:comma",      follow = false }))
hl.bind(SUPER .. " + SHIFT + N",      hl.dsp.window.move({ workspace = "special:floating",   follow = false }))

-- Mouse move/resize (was bindm -> mouse=true)
hl.bind(SUPER .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(SUPER .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- window-rules.lua (was window-rules.conf)
-- MIGRATION: windowrule = match:class X, float on, center on
--   ->  hl.window_rule({ match = { class = "X" }, float = true, center = true })
-- The 0.53 match: syntax you already used maps almost 1:1 into Lua tables.
-- float on/off -> true/false ; size W H -> {W,H} ; move X Y -> {X,Y} ; opacity -> string

-- Dialogs (by title)
hl.window_rule({ match = { title = "^Open File" },        float = true, center = true })
hl.window_rule({ match = { title = "^Select a File" },    float = true, center = true })
hl.window_rule({ match = { title = "^Choose wallpaper" }, float = true, center = true })
hl.window_rule({ match = { title = "^Open Folder" },      float = true, center = true })
hl.window_rule({ match = { title = "^Save As" },          float = true, center = true })
hl.window_rule({ match = { title = "^Library" },          float = true, center = true })
hl.window_rule({ match = { title = "^Opening" },          float = true, center = true })

-- By class
hl.window_rule({ match = { class = "^qt5ct" },                          float = true, center = true, opaque = true })
hl.window_rule({ match = { class = "^org.gnome.Nautilus" },             float = true, center = true, opaque = true, size = { 994, 635 } })
hl.window_rule({ match = { class = "^com.rafaelmardojai.Blanket" },     float = true, center = true, opaque = true, size = { 1156, 470 } })
hl.window_rule({ match = { class = "^swappy" },   opaque = true, center = true, float = true })
hl.window_rule({ match = { class = "^swayimg" },  float = true, center = true, size = { 1000, 800 } })
hl.window_rule({ match = { class = "^com.obsproject.Studio" }, opaque = true })
hl.window_rule({ match = { class = "^org.gnome.Calculator" }, float = true, center = true, opaque = true, size = { 360, 616 } })
hl.window_rule({ match = { class = "^org.gnome.Weather" },    float = true, center = true, opaque = true, size = { 1300, 503 } })
hl.window_rule({ match = { class = "^kitty" },     opaque = true })
hl.window_rule({ match = { class = "^org.pulseaudio.pavucontrol" }, float = true, center = true, size = { 1000, 540 } })
hl.window_rule({ match = { class = "^org.gnome.clocks" }, float = true, center = true, size = { 615, 563 } })
hl.window_rule({ match = { class = "^Lxappearance" }, float = true, center = true })
hl.window_rule({ match = { class = "^wdisplays" },   float = true, center = true, opaque = true, size = { 1000, 800 } })
hl.window_rule({ match = { class = "^nwg-look" },    float = true, center = true, size = { 977, 537 } })
hl.window_rule({ match = { class = "^zenity" },      float = true, center = true })
hl.window_rule({ match = { class = "^termfloat" },   float = true, center = true, size = { 960, 540 }, rounding = 5 })

-- Other (multi-condition -> single match table)
hl.window_rule({ match = { class = "kitty-idling-script" },           size = { 600, 400 }, float = true, center = true })
hl.window_rule({ match = { class = "ffplay", title = "Webcam" },      size = { 867, 489 }, float = true, center = true })
hl.window_rule({ match = { class = "mpv" },            float = true, center = true, opaque = true, size = { 1500, 850 } })
hl.window_rule({ match = { class = "org.telegram.desktop", title = "Media viewer" }, float = true, center = true })
hl.window_rule({ match = { class = "thunar" },         size = { 860, 540 } })
hl.window_rule({ match = { class = "virt-manager" },   opaque = true })
hl.window_rule({ match = { class = "btrfs-assistant" },opaque = true })
hl.window_rule({ match = { class = "kitty-sync" },     fullscreen = true })
hl.window_rule({ match = { class = "blueman-manager" },float = true, center = true })
hl.window_rule({ match = { class = "kitty-radio" },    float = true, center = true, size = { 860, 540 } })
hl.window_rule({ match = { class = "cava" },           size = { 750, 360 }, float = true, center = true })
hl.window_rule({ match = { class = "Chromium-browser" },size = { 630, 370 }, float = true, center = true })
hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true, center = true })
hl.window_rule({ match = { class = "xdg-desktop-portal-kde" }, float = true, center = true })
hl.window_rule({ match = { class = "wlfreerdp" },      float = true, center = true })
hl.window_rule({ match = { class = "org.kde.polkit-kde-authentication-agent-1" }, float = true, center = true })
hl.window_rule({ match = { class = "zen" },     workspace = "2" })
hl.window_rule({ match = { class = "ferdium" }, workspace = "3" })
hl.window_rule({ match = { class = "^freetube" }, opaque = true, workspace = "4" })
hl.window_rule({ match = { class = "WebCord" },  workspace = "special:other" })
hl.window_rule({ match = { class = "kitty-idling-script" }, workspace = "special:other silent" })

-- 
-- Layer rules #  (was layerrule = match:namespace X, blur on  ->  hl.layer_rule)
-- 
hl.layer_rule({ match = { namespace = "rofi" },                  blur = true })
hl.layer_rule({ match = { namespace = "logout_dialog" },         blur = true })
hl.layer_rule({ match = { namespace = "waybar" },                blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "supercontext" },          blur = true })
hl.layer_rule({ match = { namespace = "gtk-layer-shell" },       blur = true })
hl.layer_rule({ match = { namespace = "nwg-dock" },              blur = true })
hl.layer_rule({ match = { namespace = "launcher" },              blur = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" },         blur = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.5 })

-- 
-- Apps on special workspaces #  (move X Y -> {X,Y})
-- 
-- period workspace - controls
hl.window_rule({ match = { class = "cava" },                    workspace = "special:period", move = { 1250, 720 } })
hl.window_rule({ match = { class = "blueman-manager" },         workspace = "special:period", move = { 1200, 100 } })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, workspace = "special:period", move = { 70, 70 } })
hl.window_rule({ match = { class = "kitty-radio" },             workspace = "special:period" })
hl.window_rule({ match = { class = "com.rafaelmardojai.Blanket" }, workspace = "special:period", move = { 50, 650 } })
-- "N" workspace - floating
hl.window_rule({ match = { class = "org.gnome.Nautilus" },   workspace = "special:floating", move = { 488, 139 } })
hl.window_rule({ match = { class = "org.gnome.Calculator" }, workspace = "special:floating", move = { 1570, 57 } })
hl.window_rule({ match = { class = "org.gnome.Weather" },    workspace = "special:floating", move = { 42, 619 } })
hl.window_rule({ match = { class = "org.gnome.clocks" },     workspace = "special:floating", move = { 45, 29 } })

-- Picture-in-a-Picture
hl.window_rule({ match = { title = "Picture-in-Picture" }, opacity = "0.95 0.75", pin = true, float = true, center = true, size = { "monitor_w * 0.25", "monitor_h * 0.25" } })
hl.window_rule({ match = { class = "xwaylandvideobridge" }, opacity = "0.0 override 0.0 override", no_anim = true, no_initial_focus = true, max_size = { 1, 1 }, no_blur = true })

-- 
-- "Smart gaps" / "No gaps when only"
-- 
-- MIGRATION: old value-first form `windowrule = border_size 0, match:float 0, match:workspace w[tv1]s[false]`
--   -> property now sits inside the table, after the matchers.
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]s[false]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" },   border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]s[false]" },   rounding = 0 })

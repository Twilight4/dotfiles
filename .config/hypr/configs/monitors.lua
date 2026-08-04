-- monitors.lua (was workspaces.conf monitor lines)
-- MIGRATION: monitor=NAME,WxH@RR,XxY,SCALE  ->  hl.monitor({output,mode,position,scale})
-- MIGRATION: monitor=NAME,disable           ->  disabled = true
--
-- monitor-toggle script now writes the active profile to ~/.cache/hypr/monitor-profile
-- (was: comment/uncomment `monitor=` lines in workspaces.conf). We read it here so
-- a `hyprctl reload` after the script switches the layout. Default = main-only.
local profile = "main-only"
local f = io.open((os.getenv("HOME") or "") .. "/.cache/hypr/monitor-profile", "r")
if f then
    profile = f:read("*l") or "main-only"
    f:close()
end

if profile == "tv-only" then
    -- TV only: HDMI 4K@120, DP off
    hl.monitor({ output = "HDMI-A-1", mode = "3840x2160@120", position = "auto", scale = 2 })
    hl.monitor({ output = "DP-1",     disabled = true })
elseif profile == "two-monitors" then
    -- 2 Monitors: HDMI 1080@144 left, DP 2560x1440@180 right
    hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@144", position = "0x0",    scale = 1 })
    hl.monitor({ output = "DP-1",     mode = "2560x1440@180", position = "1920x0", scale = 1.25 })
else -- main-only (default; matches the previously active profile)
    hl.monitor({ output = "HDMI-A-1", disabled = true })
    hl.monitor({ output = "DP-1",     mode = "2560x1440@180", position = "1920x0", scale = 1.25 })
end

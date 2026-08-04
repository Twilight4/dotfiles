-- colors.lua: exposes pywal colors as a Lua table.
-- Reads the existing pywal output colors-hyprland.conf (the same file hyprlang
-- used to `source`), parsing each `$colorN = <value>` line into a table.
-- When the wallpaper changes, pywal regenerates that file and the next reload
-- picks the new colors up. MIGRATION: hyprlang `$colorN` vars do not exist in Lua.
local colors = {}
local path = (os.getenv("HOME") or "") .. "/.cache/wal/colors-hyprland.conf"
local f = io.open(path, "r")
if f then
    for line in f:read("*a"):gmatch("[^\r\n]+") do
        local k, v = line:match("^%$(color%d+)%s*=%s*(.-)%s*$")
        if k and v then colors[k] = v end
    end
    f:close()
end
-- fallback so the config still loads before the first wallpaper is set
colors.color14 = colors.color14 or "rgb(B39468)"
return colors

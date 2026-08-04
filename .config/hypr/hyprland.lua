-- hyprland.lua — Hyprland 0.55+ Lua config (migrated from hyprland.conf).
-- MIGRATION: if hyprland.lua exists, Hyprland loads it INSTEAD of hyprland.conf
-- (decided once at startup; switch at runtime with `hyprctl reload full-reset`).
-- The old .conf files are kept as an instant rollback.
require("configs/monitors")
require("configs/env")
require("configs/autostart")
require("configs/general")
require("configs/animations")
require("configs/workspaces")
require("configs/keybinds")
require("configs/window-rules")

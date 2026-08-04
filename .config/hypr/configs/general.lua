-- general.lua (was hyprland-general.conf + the general block in hyprland.conf)
-- MIGRATION: every `section { k=v }` block  ->  hl.config({ section = { k=v } })
local colors = require("colors")

hl.config({
    input = {
        kb_layout  = "pl",
        kb_options = "ctrl:nocaps",
        repeat_rate  = 50,
        repeat_delay = 300,
        follow_mouse = 2,
        float_switch_override_focus = 0,
        sensitivity   = 0,
        accel_profile = "flat",
        touchpad = {
            disable_while_typing   = true,
            natural_scroll         = true,
            scroll_factor          = 0.5, -- MIGRATION: dedup (was 0.2 then 0.5; last wins)
            clickfinger_behavior   = true,
            middle_button_emulation= false,
            tap_to_click           = true, -- was: tap-to-click
        },
    },

    general = {
        gaps_in     = 3,
        gaps_out    = 3,
        border_size = 2,
        layout      = "master",
        -- was: col.active_border = $color14 45deg  ->  gradient table
        col = {
            active_border = { colors = { colors.color14 }, angle = 45 },
        },
    },

    cursor = {
        inactive_timeout = 5,
        no_warps         = true,
        default_monitor  = "DP-2",
    },

    master = {
        orientation          = "right",
        new_on_top          = true,
        special_scale_factor= 0.9,
    },

    decoration = {
        rounding           = 0,
        active_opacity     = 1.0,
        fullscreen_opacity = 1.0,
        inactive_opacity   = 1.0,
        dim_inactive       = false,
        dim_strength       = 0.1,
        dim_special        = 0,
        blur = {
            enabled          = true,
            xray             = false,
            size             = 5,
            passes           = 3,
            ignore_opacity   = true,
            new_optimizations= true,
            noise            = 0.02,
            contrast         = 1.1,
            brightness       = 1.1,
        },
        -- MIGRATION: drop_shadow / shadow_range / col.shadow were restructured into
        -- decoration.shadow.{enabled,range,render_power,color}. All were commented
        -- out in the old config, so nothing to migrate here.
    },

    misc = {
        vrr                          = 0,
        disable_hyprland_logo        = true,
        focus_on_activate            = false,
        enable_swallow               = true,
        mouse_move_focuses_monitor   = false,
        animate_mouse_windowdragging = true,
        mouse_move_enables_dpms      = true,
        key_press_enables_dpms       = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    animations = {
        enabled = false, -- was: enabled = no
    },
})

-- MIGRATION: plugin { name { k=v } }  ->  hl.config({ plugin = { name = { k=v } } })
-- Each guarded: hyprpm loads plugins asynchronously AFTER the config runs.
if hl.plugin.hyprexpo ~= nil then
    hl.config({ plugin = { hyprexpo = {
        columns = 3, bg_col = 0xFF111111, -- rgb(111111); gap_size dropped (not in hyprexpo+ sandwich fork)
        workspace_method = "center current", skip_empty = 0,
    }}})
end

if hl.plugin.hyprwinwrap ~= nil then
    hl.config({ plugin = { hyprwinwrap = {
        class = "kitty-bg",
    }}})
end

if hl.plugin["split-monitor-workspaces"] ~= nil then
    hl.config({ plugin = { ["split-monitor-workspaces"] = {
        count = 7, keep_focused = 1,
        enable_notifications = 0, enable_persistent_workspaces = 0,
    }}})
end

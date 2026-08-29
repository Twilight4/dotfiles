-- gestures.lua — touchscreen gestures via the hyprgrass plugin (installed in
-- post-install.sh step 1 via hyprpm). Guarded: without hyprgrass loaded this
-- file is a no-op (hyprpm loads plugins asynchronously after the config runs).

if hl.plugin.hyprgrass ~= nil then
    -- sensitivity 4.0 is hyprgrass's own recommendation for tablet screens
    hl.config({ plugin = { hyprgrass = { sensitivity = 4.0 } } })

    -- Swipe up from the bottom edge: toggle the wvkbd on-screen keyboard
    hl.plugin.hyprgrass.bind({
        pattern = { kind = "edge", origin = "down", direction = "up" },
        action = hl.dsp.exec_cmd("~/.config/hypr/scripts/osk-toggle.sh"),
    })
end

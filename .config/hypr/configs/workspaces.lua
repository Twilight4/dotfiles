-- workspaces.lua (was workspaces.conf workspace lines)
-- MIGRATION: workspace=N,rules  ->  hl.workspace_rule({workspace="N", ...})
-- on-created-empty: -> on_created_empty=  (no more colon syntax)
hl.workspace_rule({ workspace = "special:comma",     on_created_empty = "emacsclient -c" })
hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "~/.config/hypr/ws-scripts/ws-monitoring" })
hl.workspace_rule({ workspace = "special:floating",   on_created_empty = "nautilus" })

-- Music workspace: Super + P on an empty ws5 pops kitty running cliamp
hl.workspace_rule({ workspace = "5", on_created_empty = "kitty --class kitty-cliamp -e cliamp" })

-- "Smart gaps" / "No gaps when only" (was flat: `workspace = w[tv1]s[false], gapsout:0, gapsin:0`)
hl.workspace_rule({ workspace = "w[tv1]s[false]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]s[false]",   gaps_out = 0, gaps_in = 0 })

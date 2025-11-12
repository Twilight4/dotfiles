require("zoxide"):setup {
	update_db = true,
}
require("full-border"):setup {
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
}
require("git"):setup()

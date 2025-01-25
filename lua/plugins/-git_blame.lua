return {
	"f-person/git-blame.nvim",
	-- load the plugin at startup
	event = "VeryLazy",
	-- Because of the keys part, you will be lazy loading this plugin.
	-- The plugin wil only load once one of the keys is used.
	-- If you want to load the plugin at startup, add something like event = "VeryLazy",
	-- or lazy = false. One of both options will work.
	opts = {
		delay = 300,
		message_template = " <author> • <date> • <summary> • <sha>",
		message_when_not_committed = " <author>, <date> • <summary>",
		date_format = "%r",
		set_extmark_options = {
			priority = 13,
		},
	},
}

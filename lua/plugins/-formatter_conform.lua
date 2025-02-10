return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			dart = { "dart_format" },
		},

		default_format_opts = {
			lsp_format = "fallback",
		},

		-- Set up format-on-save
		format_after_save = { async = true },

		-- Customize formatters
		formatters = {
			dart_format = {
				args = { "format", "-l", "100" },
			},
		},
	},
}

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

--[[

return {
	"stevearc/conform.nvim",
	opts = {
		--notify_on_error = false,

		format_after_save = {
			async = true,
			--lsp_format = "fallback",
		},

		formatters_by_ft = {
			lua = { "stylua" },
			dart = { "dart_format" },
		},
	},

	config = function(_, opts)
		local conform = require("conform")

		local dart = vim.deepcopy(require("conform.formatters.dart_format"))

		require("conform.util").add_formatter_args(dart, {
			"-l",
			"100",
		}, { append = false })

		---@cast dart conform.FormatterConfigOverride
		require("conform").formatters.dart_format = dart
	end,
}

-]]

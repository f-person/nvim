return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",

	config = function()
		local configs = require("nvim-treesitter.configs")

		configs.setup {
			ensure_installed = { "gleam" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			modules = {},
			ignore_install = {},
			auto_install = true,
		}
	end,
}

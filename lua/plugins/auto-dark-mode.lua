return {
	"f-person/auto-dark-mode.nvim",
	opts = {
		update_interval = 4000,
		set_dark_mode = function()
			---@diagnostic disable-next-line: missing-fields
			require("kanagawa-paper").setup({
				undercurl = false,
			})

			vim.api.nvim_set_option_value("background", "dark", {})
			-- vim.cmd("colorscheme lackluster")
			-- vim.cmd("colorscheme kanagawa-paper")
			vim.cmd("colorscheme dracula-soft")
		end,
		set_light_mode = function()
			vim.api.nvim_set_option_value("background", "light", {})
			vim.cmd("colorscheme peachpuff")
		end,
	},
}

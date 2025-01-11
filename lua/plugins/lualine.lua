return {
	"nvim-lualine/lualine.nvim",

	opts = {
		options = {
			icons_enabled = true,
			--			theme = "catppuccin",
			globalstatus = true,
		},
		sections = {
			lualine_a = {
				"mode",
				{
					function()
						return require 'codestats'.get_xp(0)
					end,
					fmt = function(s)
						return s and (s ~= '0' or nil) and 'c::s ' .. s .. 'xp'
					end,
				},
			},
			lualine_b = {
				"branch",
				"diff",
				{
					"diagnostics",
					sources = {
						--"nvim_lsp",
						--"nvim_diagnostic",
						"nvim_workspace_diagnostic",
					},
				},
			},
			lualine_c = { "filename" },
			lualine_x = {},
			lualine_y = { "encoding", "fileformat", "filetype", },
			--"%{CodeStatsXp()}"
		},
		lualine_z = { "progress", "location" },
	},

	extensions = { "quickfix" },
}


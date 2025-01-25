return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	opts = {
		defaults = {
			cache_piselectioncker = {
				num_pickers = 20,
			},
			layout_config = {
				horizontal = {
					height = { padding = 1 },
					width = { padding = 18 },
					prompt_position = "top",
				},
				vertical = {
					height = { padding = 1 },
					width = { padding = 18 },
					prompt_position = "top",
				},
			},
			wrap_results = true,
			mappings = {
				i = {
					["<C-h>"] = "which_key",
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
					["<C-w>"] = function()
						vim.cmd [[normal! bcw]]
					end,
				},
			},
			file_ignore_patterns = { "project/target", "project/project", "target" },
			path_display = { "smart" },
			borderchars = { "━", "┃", "━", "┃", "┏", "┓", "┛", "┗" },
			sorting_strategy = "ascending",
		},
		pickers = {
			find_files = {},
			buffers = {
				sort_mru = true,
				ignore_current_buffer = true,
			},
		},
	},
}

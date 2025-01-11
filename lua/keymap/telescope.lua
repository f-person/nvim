local M = {}

M.set_keybindings = function()
	local bind = vim.keymap.set

	local builtin = require('telescope.builtin')

	bind('n', 'gr', builtin.lsp_references)
	bind('n', '<C-p>', builtin.git_files)
	bind('n', '<leader>ws', builtin.lsp_workspace_symbols)
	bind('n', '<leader>fb', builtin.buffers)
	bind('n', '<leader>rg', builtin.live_grep)

	bind('n', '<leader>fr', builtin.resume)


	-- todo: these two are an example telescope docs, try them out
	bind('n', '<leader>ff', builtin.find_files)
	bind('n', '<leader>fh', builtin.help_tags)

	bind('n', '<leader>pf', require('telescope').extensions.smart_open.smart_open)
end

return M

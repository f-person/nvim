
local keymap_opts = { noremap = true, silent = true }

local on_attach = function(_, bufnr)
	-- Mappings
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>", keymap_opts)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", keymap_opts)
	vim.api.nvim_buf_set_keymap(
		bufnr,
		"n",
		"<leader>ca",
		'<cmd>lua require("actions-preview").code_actions()<CR>',
		keymap_opts
	)
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cd", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", keymap_opts)

	-- LSP-based omnifunc.
	vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
end


return on_attach

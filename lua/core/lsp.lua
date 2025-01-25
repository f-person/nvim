local M = {}

M.setup_language_servers = function()
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("lsp_attach_auto_diag", { clear = true }),
		callback = function(args)
			-- the buffer where the lsp attached
			---@type number
			local buffer = args.buf

			M._on_attach(nil, buffer)
		end,
	})

	local servers = require("lspconfig")

	servers.lua_ls.setup({})

	servers.dartls.setup({})

	servers.gopls.setup({})
end

M._on_attach = function(_, bufnr)
	local function bind(key, command)
		vim.api.nvim_buf_set_keymap(bufnr, "n", key, command, { noremap = true, silent = true })
	end

	bind("K", "<Cmd>lua vim.lsp.buf.hover()<CR>")

	--bind("<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")

	bind("gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
	bind("gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")

	bind("gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>")
	bind("<leader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>")

	bind("<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>")

	bind("<leader>ca", "<cmd>lua require 'actions-preview'.code_actions()<CR>")

	bind("<leader>cd", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>")

	-- open definitions etc in a floating window
	bind("gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
	bind("gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>")
	bind("gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
	bind("gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>")
	bind("gP", "<cmd>lua require('goto-preview').close_all_win()<CR>")
	bind("gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>")
end

return M

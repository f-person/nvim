if vim.g.shadowvim then
	return
end

local config_path = vim.fn.stdpath("config")
local vim_config
if config_path:find("/") then
	vim_config = config_path .. "/config.vim"
else
	vim_config = config_path .. "\\config.vim"
end

vim.api.nvim_command("source " .. vim_config)

--require("catppuccin").setup({
	--integrations = {
		--treesitter = true,
		--rainbow_delimiters = true,
		--gitgutter = true,
		--lsp_trouble = true,
		--markdown = true,
	--},

	--background = {
		--light = "latte",
		--dark = "frappe",
	--},

	--styles = {
		--comments = { "italic" },
		--conditionals = { "italic" },
		--functions = { "italic" },
		--types = { "bold" },
	--},
--})

vim.cmd.colorscheme("wildcharm")

local telescope = require("telescope")

telescope.load_extension("smart_open")

require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "catppuccin",
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
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
        lualine_y = { "encoding", "fileformat", "filetype", 
        --"%{CodeStatsXp()}"
    },
		lualine_z = { "progress", "location" },
	},
	extensions = { "quickfix" },
})

local lsp = require("lspconfig")
local cmp = require("cmp")

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	mapping = {
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif vim.fn["vsnip#available"](1) == 1 then
				feedkey("<Plug>(vsnip-expand-or-jump)", "")
			elseif has_words_before() then
				cmp.complete()
			else
				fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function()
			if cmp.visible() then
				cmp.select_prev_item()
			elseif vim.fn["vsnip#jumpable"](-1) == 1 then
				feedkey("<Plug>(vsnip-jump-prev)", "")
			end
		end, { "i", "s" }),
	},
	sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "vsnip" } }, { { name = "buffer" } }),
})

cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

cmp.setup.cmdline(":", {
	sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
-- .protocol
-- .make_client_capabilities())

-- require('lspconfig')['gopls'].setup {capabilities = capabilities}
--

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = false

lsp.gopls.setup({
	cmd = { "gopls", "--remote=auto" },
	filetypes = { "go", "gomod" },
	on_attach = on_attach,
	capabilities = capabilities,
	init_options = { analyses = { composite = false, composites = false } },
	settings = { gopls = { usePlaceholders = true, completeUnimported = true } },
})

--lsp.ccls.setup({ on_attach = on_attach })

require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

--lsp.lua_ls.setup({
	--on_attach = on_attach,
	--cmd = {
		--"/Users/fperson/Applications/lua-language-server/bin/lua-language-server",
		--"-E",
		--"/Users/fperson/Applications/lua-language-server/main.lua",
	--},
	--settings = {
		--Lua = {
			--completion = {
				--callSnippet = "Replace",
			--},
		--},
	--},
--})

lsp.jsonls.setup({ on_attach = on_attach })

require("flutter-tools").setup({
	ui = {
		notifications = "native",
	},
	lsp = {
		on_attach = on_attach,

		color = {
			enabled = true, -- whether or not to highlight color variables at all, only supported on flutter >= 2.10
			background = true, -- highlight the background
		},

		settings = {
			--lineLength = 80,
            lineLength = 100,
			--lineLength = 120,
			analysisExcludedFolders = { vim.fn.expand("$HOME/.pub-cache/"), vim.fn.expand("$HOME/fvm/versions/") },
          enableSnippets = true,
      updateImportsOnRename = true, -- Whether to update imports and other directives when files are renamed. Required for `FlutterRename` command.
		},
	},
})

lsp.pylsp.setup({ on_attach = on_attach })

lsp.vimls.setup({ on_attach = on_attach })

lsp.gdscript.setup({ on_attach = on_attach })

lsp.kotlin_language_server.setup({ on_attach = on_attach })

lsp.vuels.setup({
	on_attach = on_attach,
	init_options = {
		config = {
			vetur = { experimental = { templateInterpolationService = true } },
		},
	},
})

lsp.rust_analyzer.setup({
	cmd = { "rustup", "run", "stable", "rust-analyzer" },
	on_attach = on_attach,
})

vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics,
	{ virtual_text = false, signs = true, update_in_insert = false }
)

-- Telescope mappings
vim.api.nvim_set_keymap(
	"n",
	"gr",
	"<cmd>lua require'telescope.builtin'.lsp_references()<CR>",
	keymap_opts
)
vim.api.nvim_set_keymap("n", "<leader>rg", "<cmd>lua require'telescope.builtin'.live_grep()<CR>", keymap_opts)
vim.api.nvim_set_keymap(
	"n",
	"<C-p>",
	"<cmd>lua require'telescope.builtin'.git_files(require('telescope.themes').get_dropdown({}))<CR>",
	keymap_opts
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>pf",
	"<cmd>lua require('telescope').extensions.smart_open.smart_open()<CR>",
	keymap_opts
)
vim.api.nvim_set_keymap(
	"n",
	"<leader>ws",
	"<cmd>lua require'telescope.builtin'.lsp_workspace_symbols()<CR>",
	keymap_opts
)
vim.api.nvim_set_keymap("n", "tt", "<cmd>:Trouble diagnostics toggle<CR>", keymap_opts)
vim.api.nvim_set_keymap(
	"n",
	"<leader>bb",
	"<cmd>lua require'telescope.builtin'.buffers()<CR>",
	keymap_opts
)

vim.api.nvim_set_keymap(
	"n",
	"<leader>tr",
	"<cmd>:Telescope resume<CR>",
	keymap_opts
)

-- show numbers in telescope
vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"



--require("formatter").setup({
	--logging = false,
	--filetype = {
		--cpp = {
			--function()
				--return {
					--exe = "clang-format",
					--args = {
						--"--assume-filename",
						--vim.api.nvim_buf_get_name(0),
						--"--style",
						--"Google",
					--},
					--stdin = true,
					--cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
				--}
			--end,
		--},
	--},
--})

--require("null-ls").setup({
	--sources = {
		----require("null-ls").builtins.formatting.stylua,
		---- require("null-ls").builtins.diagnostics.eslint,
		----require("null-ls").builtins.completion.spell,
	--},
--})

--lsp.tsserver.setup({ on_attach = on_attach })

require("auto-dark-mode").setup({ update_interval = 5000 })

--require("nvim-treesitter.configs").setup({
	--ensure_installed = { "lua", "dart" },
	--sync_install = false,
	--auto_install = false,
	--indent = {
		--enable = true,
	--},
	--highlight = {
		--enable = true,
		--additional_vim_regex_highlighting = false,
	--},
--})

require("block").setup()

require("gitblame").setup({
	message_template = " <author> • <date> • <summary> • <sha>",
	message_when_not_committed = " <author>, <date> • <summary>",
	date_format = "%r",
	set_extmark_options = {
		priority = 13,
	},
})

local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

vim.cmd([[
  nnoremap - :NvimTreeToggle<CR>
]])

-- local keymap = vim.keymap -- for conciseness
-- keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- toggle file explorer

-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false --                  " Disable folding at startup.

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

nvimtree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	respect_buf_cwd = true,
	sync_root_with_cwd = true,
	view = { relativenumber = true },
})

vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>:NvimTreeToggle<CR>", keymap_opts)

vim.api.nvim_set_keymap("n", "<leader>fc", "<cmd>:NvimTreeFindFile<CR>40<C-w>>", keymap_opts)

require("barbecue").setup({
	theme = "catppuccin",
})

require('Trouble').setup()





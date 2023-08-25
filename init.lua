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

require("catppuccin").setup({
	integrations = {
		treesitter = true,
		rainbow_delimiters = true,
		gitgutter = true,
		lsp_trouble = true,
		markdown = true,
	},

	styles = {
		comments = { "italic" },
		conditionals = { "italic" },
		functions = { "italic" },
		types = { "bold" },
	},
})

vim.cmd.colorscheme("catppuccin")

local telescope = require("telescope")

telescope.setup({
	defaults = {
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
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				-- even more opts
			}),
			-- pseudo code / specification for writing custom displays, like the one
			-- for "codeactions"
			-- specific_opts = {
			--   [kind] = {
			--     make_indexed = function(items) -> indexed_items, width,
			--     make_displayer = function(widths) -> displayer
			--     make_display = function(displayer) -> function(e)
			--     make_ordinal = function(e) -> string
			--   },
			--   -- for example to disable the custom builtin "codeactions" display
			--      do the following
			--   codeactions = false,
			-- }
		},
		live_grep_args = {
			auto_quoting = true, -- enable/disable auto-quoting
		},
	},
})
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
					"nvim_lsp",
					"nvim_diagnostic",
					"nvim_workspace_diagnostic",
				},
			},
		},
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = { "encoding", "fileformat", "filetype", "%{CodeStatsXp()}" },
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
	vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", keymap_opts)
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

lsp.ccls.setup({ on_attach = on_attach })

require("neodev").setup({
	-- add any options here, or leave empty to use the default settings
})

lsp.lua_ls.setup({
	on_attach = on_attach,
	cmd = {
		"/Users/fperson/Applications/lua-language-server/bin/lua-language-server",
		"-E",
		"/Users/fperson/Applications/lua-language-server/main.lua",
	},
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
		},
	},
})

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
			lineLength = 100,
			analysisExcludedFolders = { vim.fn.expand("$HOME/.pub-cache/"), vim.fn.expand("$HOME/fvm/versions/") },
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
	"<cmd>lua require'telescope.builtin'.lsp_references(require('telescope.themes').get_dropdown({}))<CR>",
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
	"<cmd>lua require'telescope.builtin'.lsp_workspace_symbols(require('telescope.themes').get_dropdown({}))<CR>",
	keymap_opts
)
vim.api.nvim_set_keymap("n", "tt", "<cmd>:TroubleToggle<CR>", keymap_opts)
vim.api.nvim_set_keymap(
	"n",
	"<leader>bb",
	"<cmd>lua require'telescope.builtin'.buffers(require('telescope.themes').get_dropdown({}))<CR>",
	keymap_opts
)

require("formatter").setup({
	logging = false,
	filetype = {
		cpp = {
			function()
				return {
					exe = "clang-format",
					args = {
						"--assume-filename",
						vim.api.nvim_buf_get_name(0),
						"--style",
						"Google",
					},
					stdin = true,
					cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
				}
			end,
		},
	},
})

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.stylua,
		-- require("null-ls").builtins.diagnostics.eslint,
		--require("null-ls").builtins.completion.spell,
	},
})

lsp.tsserver.setup({ on_attach = on_attach })

require("auto-dark-mode").setup({ update_interval = 5000 })

local session_manager = require("session_manager")
local config_group = vim.api.nvim_create_augroup("MyConfigGroup", {})
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = config_group,
	callback = function()
		if vim.bo.filetype ~= "git" and not vim.bo.filetype ~= "gitcommit" and not vim.bo.filetype ~= "gitrebase" then
			session_manager.save_current_session()
		end
	end,
})

local session_config = require("session_manager.config")
session_manager.setup({
	autoload_mode = session_config.AutoloadMode.CurrentDir,
	autosave_last_session = true,
})

require("nvim-treesitter.configs").setup({
	ensure_installed = { "lua", "dart" },
	sync_install = false,
	auto_install = false,
	indent = {
		enable = true,
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
})

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

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.5 -- You can change this too

nvimtree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	respect_buf_cwd = true,
	sync_root_with_cwd = true,
	view = {
		relativenumber = true,
		float = {
			enable = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * WIDTH_RATIO
				local window_h = screen_h * HEIGHT_RATIO
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
				return {
					border = "rounded",
					relative = "editor",
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		},
		width = function()
			return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
		end,
	},
})

vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>:NvimTreeToggle<CR>", keymap_opts)

vim.api.nvim_set_keymap("n", "<leader>fc", "<cmd>:NvimTreeFindFileToggle<CR>", keymap_opts)

require("barbecue").setup({
	theme = "catppuccin",
})

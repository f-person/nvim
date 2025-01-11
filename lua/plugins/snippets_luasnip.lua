return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	event = "InsertEnter",
	dependencies = {
		"Neevash/awesome-flutter-snippets",
		{
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},
	config = function()
		HOME = os.getenv("HOME")
		-- load snippets from the ~/.config/nvim/snippets/ directory for the corresponding language
		--	require("luasnip/loaders/from_snipmate").lazy_load({
		--		path = { HOME .. "/.config/nvim/lua/snippets-luasnip" },
		--	})

		require("luasnip").filetype_extend("dart", { "flutter" })

		-- command to open the snippet file that belongs to the language you are editing
		vim.cmd([[
            function SnippetsEdit()
                execute ":e ~/.config/nvim/lua/snippets-luasnip" . &filetype . ".lua"
            endfunction
            command! SnippetsEdit call SnippetsEdit()
        ]])
		--		nmap('<Leader>se', ':SnippetsEdit<CR>')

		local ls = require("luasnip")
		-- some shorthands...
		local snip = ls.snippet
		local text = ls.text_node
		local insert = ls.insert_node
		local func = ls.function_node

		ls.config.setup({
			store_selection_keys = "<Tab>",
			region_check_events = "CursorMoved",
			delete_check_events = "TextChanged",
		})

		ls.add_snippets("all", {
			snip({ trig = "todo", name = "TODO_comment", dscr = "Add a TODO comment" }, {
				-- get the comment string of the buffer you are in and add a space to it
				func(function()
					return vim.api.nvim_get_option_value("commentstring", { scope = "local" }):match("^(.*)%%s")
				end, {}),
				text(" TODO: "),
				insert(0, "YOU REALLY NEED TO DO THIS"),
				func(function()
					local _, rightComment = vim.api
						.nvim_get_option_value("commentstring", {
							scope = "local",
						})
						:match("^(.*)%%s(.*)")
					return rightComment
				end, {}),
			}),
			snip({ trig = "fix", name = "FIXME_comment", dscr = "Add a FIXME comment" }, {
				-- get the comment string of the buffer you are in and add a space to it
				func(function()
					return vim.api.nvim_get_option_value("commentstring", { scope = "local" }):match("^(.*)%%s")
				end, {}),
				text(" FIXME: "),
				insert(0, "THIS NEEDS TO BE FIXED"),
				func(function()
					local _, rightComment = vim.api
						.nvim_get_option_value("commentstring", {
							scope = "local",
						})
						:match("^(.*)%%s(.*)")
					return rightComment
				end, {}),
			}),
		})
	end,
}
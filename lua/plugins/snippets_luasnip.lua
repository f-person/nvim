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
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		HOME = os.getenv("HOME")
		-- load snippets from the ~/.config/nvim/snippets/ directory for the corresponding language
		--	require("luasnip/loaders/from_snipmate").lazy_load({
		--		path = {  "./lua/snippets-luasnip" },
		--	})

		--require("luasnip").filetype_extend("dart", { "flutter" })

		local ls = require("luasnip")
		-- some shorthands...
		local snippet = ls.snippet
		local text = ls.text_node
		local insert = ls.insert_node
		local func = ls.function_node

		local rep = require("luasnip.extras").rep

		ls.config.setup {
			store_selection_keys = "<Tab>",
			region_check_events = "CursorMoved",
			delete_check_events = "TextChanged",
		}

		ls.add_snippets("all", {
			snippet({ trig = "todo", name = "TODO_comment", dscr = "Add a TODO comment" }, {
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
			snippet({ trig = "fix", name = "FIXME_comment", dscr = "Add a FIXME comment" }, {
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

		ls.add_snippets("dart", {
			snippet({ trig = "jsonser", name = "json_serializable", dscr = "Generate fromJson and toJson methods" }, {
				text("factory "),
				insert(1, "Model"),
				text("Dto.fromJson(Map<String, dynamic> json) => _$"),
				rep(1),
				text("DtoFromJson(json);"),
				text { "", "Map<String, dynamic> toJson() => _$" },
				rep(1),
				text("DtoToJson(this);"),
			}),
		})
	end,
}

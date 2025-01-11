return {
	"nvim-flutter/flutter-tools.nvim",
	opts = {
		ui = {
			notifications = "native",
		},
		lsp = {
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
				updateImportsOnRename = true
			},

			-- trying to fix formatting:
			capabilities = {
				textDocument = { formatting = { dynamicRegistration = false } },
			},
		},
	}
}

local GitSignsKeybindingManager = {}

GitSignsKeybindingManager.set_keybindings = function()
	local bind = vim.keymap.set

	-- ctrl+s to save
	bind({ "n" }, "<leader>hn", ":Gitsigns next_hunk<cr>")
	bind({ "n" }, "<leader>hp", ":Gitsigns prev_hunk<cr>")
	bind({ "n" }, "<leader>hh", ":Gitsigns preview_hunk<cr>")
end

return GitSignsKeybindingManager

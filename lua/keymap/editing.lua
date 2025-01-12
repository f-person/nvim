local M = {}

local function handle_new_line_insert(command)
	local total_lines_to_insert = vim.v.count -- start from 1
	if total_lines_to_insert == 0 then
		return command
	end

	local opposite_command = (command ~= "o" and "o") or "O"

	return table.concat({
		"<C-\\><C-n>", -- reset undo history
		command,
		"$<Esc>m`", -- insert a `$` marker for indentation
		total_lines_to_insert,
		opposite_command,
		"<Esc>", -- insert blank lines
		'g``"_s', -- return to the marker and start insert mode
	})
end

local function bind_new_line(key, command)
	vim.keymap.set("n", key, function()
		return handle_new_line_insert(command)
	end, { expr = true, silent = true })
end

M.set_keybindings = function()
	local bind = vim.keymap.set

	-- ctrl+s to save
	bind({ "n", "v", "i" }, "<c-s>", "<cmd>w<cr>")

	-- ctrl+hjkl to move between splits
	bind("n", "<c-h>", "<cmd>:wincmd h<cr>")
	bind("n", "<c-j>", "<cmd>:wincmd j<cr>")
	bind("n", "<c-k>", "<cmd>:wincmd k<cr>")
	bind("n", "<c-l>", "<cmd>:wincmd l<cr>")

	-- file tree
	bind("n", "<leader>ff", "<cmd>:Neotree toggle<cr>")
	bind("n", "<leader>fc", "<cmd>:Neotree reveal<cr>")

	-- number x 'o' & 'O'
	bind_new_line("o", "o")
	bind_new_line("O", "O")

	-- rename
	bind("n", "<leader>rr", function()
		require("live-rename").rename()
	end)

	-- arrow keys to resize currently focused split
	bind("n", "<up>", "<C-w>+")
	bind("n", "<down>", "<C-w>-")
	bind("n", "<left>", "<C-w><")
	bind("n", "<right>", "<C-w>>")
end

return M

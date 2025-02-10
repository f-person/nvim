local M = {}

local options = {
	colorcolumn = { 100 },
	ruler = true,

	tabstop = 4,
	shiftwidth = 4,

	mouse = "a",
	showmatch = true, -- highlight matching parentheses
	number = true,
	relativenumber = true,

	splitbelow = true,
	splitright = true,

	encoding = "utf-8",

	updatetime = 50, -- reduce update time for responsiveness
	hidden = true, -- allow hidden buffers
	undofile = true, -- save undo history

	-- case-insensitive search, unless capital is present
	ignorecase = true,
	smartcase = true,
}

M.set_vim_configuration_options = function()
	vim.opt.clipboard:append("unnamedplus")

	for keyOption, valueOption in pairs(options) do
		vim.opt[keyOption] = valueOption
	end
end

return M

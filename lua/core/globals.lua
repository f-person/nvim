local M = {}

local globals = {
		mapleader = ",",
}

M.set_vim_globals = function()
	for keyGlobal, valueGlobal in pairs(globals) do
	    vim.g[keyGlobal] = valueGlobal
	end
end

return M

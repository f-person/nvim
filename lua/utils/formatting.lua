local M = {}

---@param num number
---
M.format_number = function(num)
	local _, __, minus, number, fraction = tostring(num):find('([-]?)(%d+)([.]?%d*)')

	-- reverse the number-string and append a comma to all blocks of 3 digits
	number = number:reverse():gsub("(%d%d%d)", "%1,")

	-- reverse the int-string back remove an optional comma and put the 
	-- optional minus and fractional part back
	return minus .. number:reverse():gsub("^,", "") .. fraction
end

return M

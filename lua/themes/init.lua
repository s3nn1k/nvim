local M = {}

local theme_file = vim.fn.stdpath("data") .. "/theme"

M.default = "kanagawa-wave"

M.registry = {
	["kanagawa-wave"] = { lualine = "kanagawa" },
}

function M.active_name()
	local f = io.open(theme_file, "r")
	if not f then
		return M.default
	end
	local name = vim.trim(f:read("*l") or "")
	f:close()
	if M.registry[name] then
		return name
	end
	return M.default
end

function M.lualine()
	return M.registry[M.active_name()].lualine
end

function M.switch(name)
	if not M.registry[name] then
		return
	end
	local f = io.open(theme_file, "w")
	if f then
		f:write(name)
		f:close()
	end
	vim.cmd("colorscheme " .. name)
end

M.specs = {
	require("themes.kanagawa"),
}

return M

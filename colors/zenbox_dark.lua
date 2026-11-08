vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.o.background = "dark"
vim.g.colors_name = "zenbox_dark"

local modules = {
	"editor",
	"syntax",
	"treesitter",
	"lsp",
	"git",
	"plugins",
}

local groups = {}
for _, module in ipairs(modules) do
	for name, spec in pairs(require("zenbox_dark." .. module)) do
		groups[name] = spec
	end
end
for name, spec in pairs(groups) do
	vim.api.nvim_set_hl(0, name, spec)
end

local palette = require("zenbox_dark.palette")
for index, color in ipairs(palette.terminal) do
	vim.g["terminal_color_" .. (index - 1)] = color
end

-- Политика: <leader> — только длинные команды и функционал, не покрытый
-- нативными маппингами. Навигация и окна — нативные (C-w, g<Tab>, CTRL-6, [d/]d).
local g = vim.g
local map = vim.keymap

g.mapleader = " "
g.maplocalleader = " "

map.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local function opts(desc)
	return { noremap = true, silent = true, desc = desc }
end

map.set("n", "x", '"_x', opts("Delete char without yanking"))
map.set("v", "p", '"_dP', opts("Paste without overwriting yank"))
map.set("v", "<", "<gv", opts("Indent left and reselect"))
map.set("v", ">", ">gv", opts("Indent right and reselect"))
map.set("v", "J", ":m '>+1<CR>gv=gv", opts("Move selection down"))
map.set("v", "K", ":m '<-2<CR>gv=gv", opts("Move selection up"))
map.set("n", "<C-d>", "<C-d>zz", opts("Page down and center"))
map.set("n", "<C-u>", "<C-u>zz", opts("Page up and center"))

map.set("n", "<C-s>", "<cmd>w<CR>", opts("Save file"))
map.set("n", "<C-q>", "<cmd>qa<CR>", opts("Quit all"))

map.set("n", "<leader>w", function()
	local wrap = not vim.o.wrap
	vim.o.wrap = wrap
	print("Wrap: " .. (wrap and "ON" or "OFF"))
end, opts("Toggle word wrap"))

local g = vim.g
local map = vim.keymap
local km = require("core.keys")
local bufs = require("core.buffers")

g.mapleader = " "
g.maplocalleader = " "

map.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

local base_opts = { noremap = true, silent = true }
local function opts(desc, extra)
	return km.opts(base_opts, desc, extra)
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

map.set("n", "<Up>", "<cmd>resize -2<CR>", opts("Resize window up"))
map.set("n", "<Down>", "<cmd>resize +2<CR>", opts("Resize window down"))
map.set("n", "<Left>", "<cmd>vertical resize -2<CR>", opts("Resize window left"))
map.set("n", "<Right>", "<cmd>vertical resize +2<CR>", opts("Resize window right"))

map.set("n", "<C-h>", "<C-w>h", opts("Go to window left"))
map.set("n", "<C-j>", "<C-w>j", opts("Go to window down"))
map.set("n", "<C-k>", "<C-w>k", opts("Go to window up"))
map.set("n", "<C-l>", "<C-w>l", opts("Go to window right"))

map.set("n", "<leader>sv", "<C-w>v", opts("Split vertically"))
map.set("n", "<leader>sh", "<C-w>s", opts("Split horizontally"))
map.set("n", "<leader>se", "<C-w>=", opts("Equalize splits"))
map.set("n", "<leader>cw", "<cmd>close<CR>", opts("Close window"))

map.set("n", "<leader>q", bufs.smart_close, opts("Close buffer"))
map.set("n", "<Tab>", bufs.safe_buffer_switch("next"), opts("Next buffer"))
map.set("n", "<S-Tab>", bufs.safe_buffer_switch("previous"), opts("Previous buffer"))

map.set("n", "g<Tab>", function()
	local last = vim.fn.tabpagenr("#")
	if last > 0 then
		vim.cmd("tabnext " .. last)
	end
end, opts("Go to last used tab"))

map.set("n", "<leader>tw", function()
	local wrap = not vim.o.wrap
	vim.o.wrap = wrap
	print("Wrap: " .. (wrap and "ON" or "OFF"))
end, opts("Toggle word wrap"))

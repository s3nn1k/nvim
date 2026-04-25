-- aliases
local g = vim.g
local map = vim.keymap
local bufs = require("package.buffers")
local smart_goto = require("package.smart_goto")
local km = require("package.keymaps")

-- leader key
g.mapleader = " "
g.maplocalleader = " "

-- disable spacebar default behavior (for leader key)
map.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = km.desc("Disable <Space> (leader)") })

-- disable default hover
map.set("n", "K", "<Nop>", { silent = true, desc = km.desc("Disable default hover") })

-- default options
local base_opts = { noremap = true, silent = true }
local function opts(desc, extra)
	return km.opts(base_opts, desc, extra)
end

-- delete single character without copying into register
map.set("n", "x", '"_x', opts("Delete char without yanking"))

-- keep last yanked after pasing
map.set("v", "p", '"_dP', opts("Paste without overwriting yank"))
-- stay in indent mode
map.set("v", "<", "<gv", opts("Indent left and reselect"))
map.set("v", ">", ">gv", opts("Indent right and reselect"))

-- move up and down with cursor centered
map.set("n", "<C-d>", "<C-d>zz", opts("Page down and center"))
map.set("n", "<C-u>", "<C-u>zz", opts("Page up and center"))

-- select and move blocks of text
map.set("v", "J", ":m '>+1<CR>gv=gv", opts("Move selection down"))
map.set("v", "K", ":m '<-2<CR>gv=gv", opts("Move selection up"))

-- neovim management
map.set("n", "<C-s>", "<cmd> w <CR>", opts("Save file"))
map.set("n", "<C-q>", "<cmd> qa <CR>", opts("Quit all"))

-- resize window
map.set("n", "<Up>", "<cmd> resize -2<CR>", opts("Resize window up"))
map.set("n", "<Down>", "<cmd> resize +2<CR>", opts("Resize window down"))
map.set("n", "<Left>", "<cmd> vertical resize -2<CR>", opts("Resize window left"))
map.set("n", "<Right>", "<cmd> vertical resize +2<CR>", opts("Resize window right"))

-- navigate between windows
map.set("n", "<C-k>", "<cmd> wincmd k <CR>", opts("Go to window up"))
map.set("n", "<C-j>", "<cmd> wincmd j <CR>", opts("Go to window down"))
map.set("n", "<C-h>", "<cmd> wincmd h <CR>", opts("Go to window left"))
map.set("n", "<C-l>", "<cmd> wincmd l <CR>", opts("Go to window right"))

-- windows management
map.set("n", "<leader>sv", "<C-w>v", opts("Split vertically"))
map.set("n", "<leader>sh", "<C-w>s", opts("Split horizontally"))
map.set("n", "<leader>se", "<C-w>=", opts("Equalize splits"))
map.set("n", "<leader>cw", "<cmd> close <CR>", opts("Close window"))

-- buffers management
map.set("n", "<leader>q", bufs.smart_close, opts("Close buffer"))

-- navigate between buffers
map.set("n", "<Tab>", bufs.safe_buffer_switch("next"), opts("Next buffer"))
map.set("n", "<S-Tab>", bufs.safe_buffer_switch("previous"), opts("Previous buffer"))

-- go to [d]efinition or go to file using one hotkey
map.set("n", "<leader>d", smart_goto.smart_goto, opts("Smart goto"))

-- toggle word wrap
map.set("n", "<leader>tw", function()
	vim.opt.wrap = not vim.opt.wrap:get()
	print("Wrap: " .. (vim.opt.wrap:get() and "ON" or "OFF"))
end, opts("Toggle word wrap"))

-- plugin-specified mappings listed in the same named .lua files

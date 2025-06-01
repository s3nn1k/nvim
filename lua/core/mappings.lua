-- aliases
local g = vim.g
local map = vim.keymap
local bufs = require("package.buffers")

-- leader key
g.mapleader = " "
g.maplocalleader = " "

-- disable spacebar default behavior (for leader key)
map.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- disable visual block (for terminal vertical split)
map.set("n", "<C-V>", "<Nop>", { silent = true })

-- disable default hover
map.set("n", "K", "<Nop>", { silent = true })

-- default options
local opts = { noremap = true, silent = true }

-- delete single character without copying into register
map.set("n", "x", '"_x', opts)

-- keep last yanked after pasing
map.set("v", "p", '"_dP', opts)
-- stay in indent mode
map.set("v", "<", "<gv", opts)
map.set("v", ">", ">gv", opts)

-- move up and down with cursor centered
map.set("n", "<C-d>", "<C-d>zz", opts)
map.set("n", "<C-u>", "<C-u>zz", opts)

-- select and move blocks of text
map.set("v", "J", ":m '>+1<CR>gv=gv", opts)
map.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- neovim management
map.set("n", "<C-s>", "<cmd> w <CR>", opts) -- save file
map.set("n", "<C-q>", "<cmd> qa <CR>", opts) -- quit

-- resize window
map.set("n", "<Up>", "<cmd> resize -2<CR>", opts)
map.set("n", "<Down>", "<cmd> resize +2<CR>", opts)
map.set("n", "<Left>", "<cmd> vertical resize -2<CR>", opts)
map.set("n", "<Right>", "<cmd> vertical resize +2<CR>", opts)

-- navigate between windows
map.set("n", "<C-k>", "<cmd> wincmd k <CR>", opts)
map.set("n", "<C-j>", "<cmd> wincmd j <CR>", opts)
map.set("n", "<C-h>", "<cmd> wincmd h <CR>", opts)
map.set("n", "<C-l>", "<cmd> wincmd l <CR>", opts)

-- windows management
map.set("n", "<leader>sv", "<C-w>v", opts) -- split vertical
map.set("n", "<leader>sh", "<C-w>s", opts) -- split horizontal
map.set("n", "<leader>se", "<C-w>=", opts) -- set equal
map.set("n", "<leader>cw", "<cmd> close <CR>", opts) -- close window

-- buffers management
map.set("n", "<leader>q", bufs.smart_close, opts) -- quit buffer

-- navigate between buffers
map.set("n", "<Tab>", bufs.safe_buffer_switch("next"), opts)
map.set("n", "<S-Tab>", bufs.safe_buffer_switch("previous"), opts)

-- plugin-specified mappings listed in the same named .lua files

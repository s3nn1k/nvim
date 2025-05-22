-- aliases
local g = vim.g
local opt = vim.opt

-- disable netrw
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1
g.loaded_netrwFileHandlers = 1

-- line numbers
opt.number = true
opt.relativenumber = true

-- sign column
opt.signcolumn = "yes"

-- disable wrap
opt.wrap = false
opt.linebreak = true

-- use system clipboard
opt.clipboard = "unnamedplus"

-- nerd font on
g.have_herd_font = true

-- autoindent
opt.autoindent = true
opt.smartindent = true

-- searching
opt.ignorecase = true
opt.smartcase = true

-- tabs
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- disable statusline
opt.showmode = false
opt.ruler = false
opt.laststatus = 0
opt.showcmd = false

-- minimal lines and columns to keep on scroll
opt.scrolloff = 4
opt.sidescrolloff = 8

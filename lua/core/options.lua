local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

opt.wrap = false
opt.linebreak = true

opt.clipboard = "unnamedplus"

opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

opt.scrolloff = 4
opt.sidescrolloff = 8

opt.swapfile = false
opt.undofile = true
opt.foldlevelstart = 3

opt.termguicolors = true
opt.fillchars = { eob = " " }

opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 0

opt.completeopt = { "menu", "menuone", "noselect", "popup" }
vim.o.winborder = "single"
vim.o.pumborder = "single"

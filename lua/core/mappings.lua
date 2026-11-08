-- Политика маппингов:
-- 1. <leader> — только длинные команды и функционал, не покрытый нативом.
-- 2. Нативные клавиши в активном использовании не затираем (C-v, H/L).
-- 3. Неиспользуемые клавиши можно отдать под нужный функционал, даже дублирующий
--    нативный (стрелки -> ресайз, C-h/j/k/l -> окна).
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

map.set("n", "<C-h>", "<C-w>h", opts("Go to window left"))
map.set("n", "<C-j>", "<C-w>j", opts("Go to window down"))
map.set("n", "<C-k>", "<C-w>k", opts("Go to window up"))
map.set("n", "<C-l>", "<C-w>l", opts("Go to window right"))

map.set("n", "<Up>", "<cmd>resize -2<CR>", opts("Resize window up"))
map.set("n", "<Down>", "<cmd>resize +2<CR>", opts("Resize window down"))
map.set("n", "<Left>", "<cmd>vertical resize -2<CR>", opts("Resize window left"))
map.set("n", "<Right>", "<cmd>vertical resize +2<CR>", opts("Resize window right"))

-- Tab и C-i — один байт: jumplist-вперёд переносим на C-n (только normal; в insert
-- C-n/p — автодополнение), Tab/S-Tab отдаём буферам.
map.set("n", "<C-n>", "<C-i>", opts("Jump list forward"))
map.set("n", "<Tab>", "<cmd>bnext<CR>", opts("Next buffer"))
map.set("n", "<S-Tab>", "<cmd>bprevious<CR>", opts("Previous buffer"))

map.set("n", "gD", "<Nop>", { silent = true })

map.set("n", "<leader>w", function()
	local wrap = not vim.o.wrap
	vim.o.wrap = wrap
	print("Wrap: " .. (wrap and "ON" or "OFF"))
end, opts("Toggle word wrap"))

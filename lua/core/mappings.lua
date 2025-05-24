-- aliases
local g = vim.g
local map = vim.keymap

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

-- check if this buffer is floating or special
local function is_buf_special(buf)
	return vim.bo[buf].buftype ~= "" or vim.api.nvim_win_get_config(0).relative ~= ""
end

-- check if this buffer is not opened in other windows
local function is_buf_closed(buf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			return false
		end
	end

	return true
end

-- default :bd works bad with neo-tree and layout
local function smart_close()
	local buf = vim.api.nvim_get_current_buf()

	if is_buf_special(buf) then
		vim.cmd("bd")
		return
	end

	-- get only loaded buffers
	local bufs = vim.tbl_filter(function(b)
		return vim.api.nvim_buf_is_loaded(b) and not is_buf_special(b)
	end, vim.api.nvim_list_bufs())

	-- get index of current buffer
	local curr_idx = nil
	for i, b in ipairs(bufs) do
		if b == buf then
			curr_idx = i
			break
		end
	end

	-- if it's last buffer or not exists - close
	if not curr_idx or #bufs == 1 then
		vim.cmd("bd")
		return
	end

	-- get next buffer index
	local next_buf = nil

	if curr_idx == 1 then
		next_buf = bufs[curr_idx + 1]
	else
		next_buf = bufs[curr_idx - 1]
	end

	-- set next for this window
	vim.api.nvim_set_current_buf(next_buf)

	if is_buf_closed(buf) then
		vim.cmd("bd " .. buf)
	end
end

-- buffers management
map.set("n", "<leader>q", smart_close, opts) -- quit buffer

-- default :bnext and :bprevious works bad with Lazy window
local function safe_buffer_switch(direction)
	return function()
		local buf = vim.api.nvim_get_current_buf()

		if is_buf_special(buf) then
			return
		else
			if direction == "next" then
				vim.cmd("bnext")
			else
				vim.cmd("bprevious")
			end
		end
	end
end
-- navigate between buffers
map.set("n", "<Tab>", safe_buffer_switch("next"), opts)
map.set("n", "<S-Tab>", safe_buffer_switch("previous"), opts)

-- plugin-specified mappings listed in the same named .lua files

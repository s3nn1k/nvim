local M = {}

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
function M.smart_close()
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

-- default :bnext and :bprevious works bad with Lazy window
function M.safe_buffer_switch(direction)
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

-- return module table
return M

local M = {}

local function is_buf_special(buf)
	return vim.bo[buf].buftype ~= "" or vim.api.nvim_win_get_config(0).relative ~= ""
end

local function is_buf_closed(buf)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_buf(win) == buf then
			return false
		end
	end

	return true
end

function M.smart_close()
	local buf = vim.api.nvim_get_current_buf()

	if is_buf_special(buf) then
		vim.cmd("bd")
		return
	end

	local bufs = vim.tbl_filter(function(b)
		return vim.api.nvim_buf_is_loaded(b) and not is_buf_special(b)
	end, vim.api.nvim_list_bufs())

	local curr_idx = nil
	for i, b in ipairs(bufs) do
		if b == buf then
			curr_idx = i
			break
		end
	end

	if not curr_idx or #bufs == 1 then
		vim.cmd("bd")
		return
	end

	local next_buf = nil

	if curr_idx == 1 then
		next_buf = bufs[curr_idx + 1]
	else
		next_buf = bufs[curr_idx - 1]
	end

	vim.api.nvim_set_current_buf(next_buf)

	if is_buf_closed(buf) then
		vim.cmd("bd " .. buf)
	end
end

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

return M

local M = {}

function M.open()
	local themes = require("themes")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values

	local before = vim.g.colors_name
	local confirmed = false

	local function preview_selection(prompt_bufnr, direction)
		return function()
			if direction > 0 then
				actions.move_selection_next(prompt_bufnr)
			else
				actions.move_selection_previous(prompt_bufnr)
			end
			local entry = action_state.get_selected_entry()
			if entry then
				vim.cmd("colorscheme " .. entry.value)
			end
		end
	end

	pickers
		.new({}, {
			prompt_title = "Theme",
			finder = finders.new_table({ results = vim.tbl_keys(themes.registry) }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				map("i", "<Down>", preview_selection(prompt_bufnr, 1))
				map("i", "<Up>", preview_selection(prompt_bufnr, -1))
				map("i", "<C-n>", preview_selection(prompt_bufnr, 1))
				map("i", "<C-p>", preview_selection(prompt_bufnr, -1))
				map("i", "<esc>", function()
					actions.close(prompt_bufnr)
					if not confirmed then
						vim.cmd("colorscheme " .. before)
					end
				end)
				actions.select_default:replace(function()
					local entry = action_state.get_selected_entry()
					confirmed = true
					actions.close(prompt_bufnr)
					themes.switch(entry and entry.value or before)
				end)
				return true
			end,
		})
		:find()
end

return M

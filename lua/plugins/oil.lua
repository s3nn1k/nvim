local function ignored_entries(dir)
	local set = {}
	local ok, out = pcall(vim.fn.system, {
		"git",
		"-C",
		dir,
		"ls-files",
		"--ignored",
		"--exclude-standard",
		"--others",
		"--directory",
	})
	if ok and vim.v.shell_error == 0 then
		for line in out:gmatch("[^\n]+") do
			set[line:gsub("/$", "")] = true
		end
	end
	return set
end

return {
	"stevearc/oil.nvim",
	dependencies = {
		{
			"nvim-tree/nvim-web-devicons",
			opts = { color_icons = false },
		},
	},
	cmd = { "Oil" },
	keys = {
		{
			"<leader>e",
			function()
				if vim.bo.filetype == "oil" then
					require("oil").close()
				else
					require("oil").open()
				end
			end,
			desc = "Toggle file explorer (parent directory)",
		},
	},
	opts = {
		columns = { "icon" },
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			is_hidden_file = function(name, bufnr)
				if name == ".git" then
					return true
				end
				local set = vim.b[bufnr].oil_git_ignored
				if set == nil then
					local dir = require("oil").get_current_dir(bufnr)
					set = dir and ignored_entries(dir) or {}
					vim.b[bufnr].oil_git_ignored = set
				end
				return set[name] == true
			end,
		},

		-- Дефолтные мапы oil перекрывают наши глобальные (C-s :w, C-h/l окна);
		-- навигация наверх - <CR> по "../", остальное через :h oil-actions
		use_default_keymaps = false,
		keymaps = {
			["<CR>"] = "actions.select",
		},
	},
}

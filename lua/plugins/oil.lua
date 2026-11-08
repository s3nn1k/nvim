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
		},

		-- Дефолтные мапы oil перекрывают наши глобальные (C-s :w, C-h/l окна);
		-- навигация наверх - <CR> по "../", остальное через :h oil-actions
		use_default_keymaps = false,
		keymaps = {
			["<CR>"] = "actions.select",
		},
	},
}

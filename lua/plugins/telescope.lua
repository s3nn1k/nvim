return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = "LspAttach",
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fs.root(0, ".git") })
			end,
			desc = "Find files (project root)",
		},
		{
			"<leader>fs",
			function()
				require("telescope.builtin").live_grep({ cwd = vim.fs.root(0, ".git") })
			end,
			desc = "Live grep (project root)",
		},
		{
			"<leader>fw",
			mode = { "n", "v" },
			function()
				require("telescope.builtin").grep_string({ cwd = vim.fs.root(0, ".git") })
			end,
			desc = "Grep word (project root)",
		},
	},
	config = function()
		local actions = require("telescope.actions")
		local actions_set = require("telescope.actions.set")

		local function jump_up(prompt_bufnr)
			actions_set.shift_selection(prompt_bufnr, -5)
		end

		local function jump_down(prompt_bufnr)
			actions_set.shift_selection(prompt_bufnr, 5)
		end

		require("telescope").setup({
			defaults = {
				layout_strategy = "flex",
				layout_config = {
					horizontal = {
						height = 0.95,
						width = 0.95,
						preview_width = 0.4,
						preview_cutoff = 80,
					},
					vertical = {
						width = 0.95,
						height = 0.95,
						preview_height = 0.6,
						preview_cutoff = 40,
					},
					flex = {
						flip_columns = 90,
						flip_lines = 20,
					},
				},
				path_display = { "filename_first" },
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<Down>"] = actions.move_selection_next,
						["<Up>"] = actions.move_selection_previous,
						["<CR>"] = actions.select_default,
						["<C-k>"] = actions.preview_scrolling_up,
						["<C-j>"] = actions.preview_scrolling_down,
						["<C-h>"] = actions.preview_scrolling_left,
						["<C-l>"] = actions.preview_scrolling_right,
						["<C-u>"] = jump_up,
						["<C-d>"] = jump_down,

						["<C-n>"] = false,
						["<C-p>"] = false,
						["<Tab>"] = false,
						["<S-Tab>"] = false,
						["j"] = false,
						["k"] = false,
						["H"] = false,
						["M"] = false,
						["L"] = false,
						["gg"] = false,
						["G"] = false,
						["<C-x>"] = false,
						["<C-v>"] = false,
						["<C-f>"] = false,
						["<C-t>"] = false,
						["<M-f>"] = false,
						["<M-k>"] = false,
						["<C-/>"] = false,
						["?"] = false,
						["<C-c>"] = false,
						["<C-q>"] = false,
						["<M-q>"] = false,
						["<C-r><C-w>"] = false,
						["<C-r><C-a>"] = false,
						["<C-r><C-f>"] = false,
						["<C-r><C-l>"] = false,
					},
				},
				file_ignore_patterns = {
					".git",
				},
			},
		})
	end,
}

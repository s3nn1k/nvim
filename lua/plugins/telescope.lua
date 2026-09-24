return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files({ cwd = vim.fs.root(0, { ".git" }) })
			end,
			desc = require("package.keymaps").desc("Find files (project root)"),
		},
		{
			"<leader>fs",
			function()
				require("telescope.builtin").live_grep({ cwd = vim.fs.root(0, { ".git" }) })
			end,
			desc = require("package.keymaps").desc("Live grep (project root)"),
		},
		{
			"<leader>fw",
			mode = { "n", "v" },
			function()
				require("telescope.builtin").grep_string({ cwd = vim.fs.root(0, { ".git" }) })
			end,
			desc = require("package.keymaps").desc("Grep word (project root)"),
		},
		{
			"<leader>gn",
			function()
				require("telescope.builtin").git_branches()
			end,
			desc = require("package.keymaps").desc("Git branches"),
		},
		{
			"<leader>gc",
			function()
				require("telescope.builtin").git_commits()
			end,
			desc = require("package.keymaps").desc("Git commits"),
		},
		{
			"<leader>fd",
			function()
				require("telescope.builtin").diagnostics()
			end,
			desc = require("package.keymaps").desc("Diagnostics"),
		},
		{
			"<leader>fb",
			function()
				require("telescope.builtin").buffers()
			end,
			desc = require("package.keymaps").desc("Buffers"),
		},
		{
			"<leader>jl",
			function()
				require("telescope.builtin").jumplist()
			end,
			desc = require("package.keymaps").desc("Jumplist"),
		},
		{
			"<leader>ft",
			function()
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
						actions.move_selection(prompt_bufnr, direction)
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
			end,
			desc = require("package.keymaps").desc("Pick theme"),
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
			extensions = {
				fzf = {},
			},
			defaults = {
				layout_config = {
					horizontal = {
						height = 0.9,
						width = 0.9,
						preview_width = 0.4,
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

						-- disabled
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

		require("telescope").load_extension("fzf")
	end,
}

return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				layout_config = {
					horizontal = {
						height = 0.9,
						width = 0.9,
						preview_width = 0.6,
					},
				},
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<Tab>"] = actions.move_selection_next,
						["<S-Tab>"] = actions.move_selection_previous,
						["<CR>"] = actions.select_default,
						["<C-k>"] = actions.preview_scrolling_up,
						["<C-j>"] = actions.preview_scrolling_down,
						["<C-h>"] = actions.preview_scrolling_left,
						["<C-l>"] = actions.preview_scrolling_right,

						-- disabled
						["<C-n>"] = false,
						["<C-p>"] = false,
						["<Down>"] = false,
						["<Up>"] = false,
						["j"] = false,
						["k"] = false,
						["H"] = false,
						["M"] = false,
						["L"] = false,
						["gg"] = false,
						["G"] = false,
						["<C-x>"] = false,
						["<C-v>"] = false,
						["<C-u>"] = false,
						["<C-d>"] = false,
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

		-- this function returns opts with cwd for current work directory
		local function root_opts()
			local function is_git_repo()
				vim.fn.system("git rev-parse --is-inside-work-tree")
				return vim.v.shell_error == 0
			end

			local function get_git_root()
				local dot_git_path = vim.fn.finddir(".git", ".;")
				return vim.fn.fnamemodify(dot_git_path, ":h")
			end

			local opts = {}

			if is_git_repo() then
				opts = {
					cwd = get_git_root(),
				}
			end

			return opts
		end

		local builtin = require("telescope.builtin")

		local function find_files_from_project_root()
			builtin.find_files(root_opts())
		end

		local function live_grep_from_project_root()
			builtin.live_grep(root_opts())
		end

		local function grep_string_from_project_root()
			builtin.grep_string(root_opts())
		end

		local map = vim.keymap
		local opts = { noremap = true, silent = true }

		map.set("n", "<leader>ff", find_files_from_project_root, opts)
		map.set("n", "<leader>fs", live_grep_from_project_root, opts)
		map.set({ "n", "v" }, "<leader>fw", grep_string_from_project_root, opts)
		map.set("n", "<leader>gb", builtin.git_branches, opts)
		map.set("n", "<leader>gc", builtin.git_commits, opts)
		map.set("n", "<leader>fd", builtin.diagnostics, opts)
		map.set("n", "<leader>fb", builtin.buffers, opts)
	end,
}

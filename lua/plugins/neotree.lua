return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local map = vim.keymap
		local opts = { noremap = true, silent = true }

		map.set("n", "<leader>te", "<cmd> Neotree toggle reveal <CR>", opts)
		map.set("n", "<leader>tg", "<cmd> Neotree toggle git_status <CR>", opts)

		require("neo-tree").setup({
			popup_border_style = "single",
			default_component_configs = {
				indent = { with_markers = true },
				icon = { folder_empty = "" },
				name = { use_git_status_colors = false },
				git_status = {
					symbols = {
						-- change type
						added = "N",
						modified = "M",
						deleted = "D", -- this can only be used in the git_status source
						renamed = "R", -- this can only be used in the git_status source

						-- status type
						untracked = "U",
						ignored = "",
						unstaged = "U",
						staged = "S",
						conflict = "C",
					},
				},
			},

			window = {
				position = "right",
				float_opts = {
					border = "single",
				},
				mappings = {
					["<cr>"] = "open",
					["<2-leftmouse>"] = "open",
					["<esc>"] = "close_window",
					["a"] = {
						"add",
						-- this command supports bash style brace expansion "x{a,b,c}" -> xa,xb,xc
						config = {
							show_path = "none", -- "relative", "absolute"
						},
					},
					["A"] = "add_directory",
					["c"] = "copy", -- takes text input for destination
					["m"] = "move", -- same
					["d"] = "delete",
					["r"] = "rename",
					["y"] = "copy_to_clipboard",
					["p"] = "paste_from_clipboard",

					-- disabled
					["<space>"] = "none",
					["l"] = "none",
					["s"] = "none",
					["t"] = "none",
					["w"] = "none",
					["z"] = "none",
					["x"] = "none",
					["q"] = "none",
					["?"] = "none",
					["<"] = "none",
					[">"] = "none",
					["i"] = "none",
				},
			},

			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false, -- only works on Windows for hidden files/directories

					always_show_by_pattern = {
						".env*",
						".gitignore*",
					},

					hide_by_name = {
						".git",
					},
				},

				hijack_netrw_behavior = "open_current",

				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["H"] = "toggle_hidden",
						["/"] = "fuzzy_finder",
						["D"] = "fuzzy_finder_directory",

						-- disabled
						["#"] = "none",
						["f"] = "none",
						["<c-x>"] = "none",
						["[g"] = "none",
						["]g"] = "none",
						["o"] = "none",
						["oc"] = "none",
						["od"] = "none",
						["og"] = "none",
						["om"] = "none",
						["on"] = "none",
						["os"] = "none",
						["ot"] = "none",
					},

					fuzzy_finder_mappings = {
						["<C-n>"] = "move_cursor_down",
						["<C-p>"] = "move_cursor_up",

						-- disabled
						["<up>"] = "none",
						["<down>"] = "none",
					},
				},
			},

			-- disabled because of telescope usage
			buffers = {
				window = {
					mappings = {
						["bd"] = "none",
						["<bs>"] = "none",
						["."] = "none",
						["o"] = "none",
						["oc"] = "none",
						["od"] = "none",
						["om"] = "none",
						["on"] = "none",
						["os"] = "none",
						["ot"] = "none",
					},
				},
			},

			git_status = {
				window = {
					mappings = {
						["A"] = "git_add_all",
						["u"] = "git_unstage_file",
						["a"] = "git_add_file",
						["r"] = "git_revert_file",
						["c"] = "git_commit",

						-- disabled
						["p"] = "none",
						["cap"] = "none",
						["o"] = "none",
						["oc"] = "none",
						["od"] = "none",
						["om"] = "none",
						["on"] = "none",
						["os"] = "none",
						["ot"] = "none",
					},
				},
			},
		})
	end,
}

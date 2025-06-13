return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("bufferline").setup({
			options = {
				mode = "buffers",
				themable = true,
				separator_style = { "", "" },
				diagnostics = "nvim_lsp",
				indicator = {
					style = "none",
				},
				offsets = {
					{
						filetype = "neo-tree",
						text = "Neo-Tree",
						highlight = "Directory",
						text_align = "center",
						separator = true,
					},
				},
			},

			-- disable background
			highlights = {
				fill = { bg = "NONE" },
				offset_separator = { bg = "NONE" },
				trunc_marker = { bg = "NONE" },

				tab_selected = { bg = "NONE" },
				tab_separator_selected = { bg = "NONE" },

				close_button_visible = { bg = "NONE" },
				close_button_selected = { bg = "NONE" },

				buffer_visible = { bg = "NONE" },
				buffer_selected = { bg = "NONE" },

				numbers_visible = { bg = "NONE" },
				numbers_selected = { bg = "NONE" },

				diagnostic_visible = { bg = "NONE" },
				diagnostic_selected = { bg = "NONE" },

				hint_visible = { bg = "NONE" },
				hint_selected = { bg = "NONE" },

				hint_diagnostic_visible = { bg = "NONE" },
				hint_diagnostic_selected = { bg = "NONE" },

				info_visible = { bg = "NONE" },
				info_selected = { bg = "NONE" },

				info_diagnostic_visible = { bg = "NONE" },
				info_diagnostic_selected = { bg = "NONE" },

				warning_visible = { bg = "NONE" },
				warning_selected = { bg = "NONE" },

				warning_diagnostic_visible = { bg = "NONE" },
				warning_diagnostic_selected = { bg = "NONE" },

				error_visible = { bg = "NONE" },
				error_selected = { bg = "NONE" },

				error_diagnostic_visible = { bg = "NONE" },
				error_diagnostic_selected = { bg = "NONE" },

				modified_visible = { bg = "NONE" },
				modified_selected = { bg = "NONE" },

				duplicate_selected = { bg = "NONE" },
				duplicate_visible = { bg = "NONE" },

				separator_selected = { bg = "NONE" },
				separator_visible = { bg = "NONE" },

				indicator_visible = { bg = "NONE" },
				indicator_selected = { bg = "NONE" },

				pick_selected = { bg = "NONE" },
				pick_visible = { bg = "NONE" },

				-- tab = { bg = "NONE" },
				-- tab_separator = { bg = "NONE" },
				-- tab_close = { bg = "NONE" },

				-- pick = { bg = "NONE" },
				-- close_button = { bg = "NONE" },
				-- separator = { bg = "NONE" },
				-- numbers = { bg = "NONE" },
				-- background = { bg = "NONE" },

				-- modified = { bg = "NONE" },
				-- duplicate = { bg = "NONE" },

				-- hint = { bg = "NONE" },
				-- info = { bg = "NONE" },
				-- error = { bg = "NONE" },
				-- warning = { bg = "NONE" },

				-- diagnostic = { bg = "NONE" },
				-- error_diagnostic = { bg = "NONE" },
				-- warning_diagnostic = { bg = "NONE" },
				-- info_diagnostic = { bg = "NONE" },
				-- hint_diagnostic = { bg = "NONE" },
			},
		})
	end,
}

return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			transparent = false,
			colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
			overrides = function(colors)
				local theme = colors.theme

				return {
					-- Telescope
					TelescopeTitle = { fg = theme.ui.special, bold = true },
					TelescopePromptNormal = { bg = theme.ui.bg_p1 },
					TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
					TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

					-- Floats
					NormalFloat = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					FloatBorder = { bg = theme.ui.bg_m1, fg = theme.ui.bg_m1 },

					-- Noice cmdline popup
					NoiceCmdlinePopup = { bg = theme.ui.bg_dim },
					NoiceCmdlineIconCmdline = { fg = theme.ui.special },
					NoiceCmdlinePopupBorder = {
						fg = theme.ui.special,
					},

					-- Noice search popup (/ and ?)
					NoiceCmdlinePopupSearch = { bg = theme.ui.bg_dim },
					NoiceCmdlineIconSearch = { fg = theme.ui.special },
					NoiceCmdlinePopupBorderSearch = {
						fg = theme.ui.special,
					},
				}
			end,
		})

		vim.cmd("colorscheme kanagawa-wave")
	end,
}

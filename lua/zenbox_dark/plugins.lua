local palette = require("zenbox_dark.palette")

return {
	TelescopeNormal = { fg = palette.fg, bg = palette.bg },
	TelescopeBorder = { fg = palette.overlay1, bg = palette.bg },
	TelescopePromptTitle = { fg = palette.purple, bold = true },
	TelescopeResultsTitle = { fg = palette.overlay1 },
	TelescopePreviewTitle = { fg = palette.overlay1 },
	TelescopeSelection = { bg = palette.selection, bold = true },
	TelescopeMatching = { fg = palette.yellow, bold = true },
	TelescopePromptPrefix = { fg = palette.purple },

	NoiceCmdlinePopup = { bg = palette.bg },
	NoiceCmdlinePopupBorder = { fg = palette.overlay1, bg = palette.bg },
	NoiceCmdlinePopupBorderSearch = { fg = palette.overlay1, bg = palette.bg },
	NoiceConfirmBorder = { fg = palette.orange, bg = palette.bg },
	NoiceMini = { bg = palette.bg },
}

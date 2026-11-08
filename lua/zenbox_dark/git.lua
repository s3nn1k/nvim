local palette = require("zenbox_dark.palette")

return {
	DiffAdd = { bg = palette.diff_add },
	DiffChange = { bg = palette.diff_change },
	DiffDelete = { bg = palette.diff_delete },
	DiffText = { bg = palette.diff_text, bold = true },
	DiffAdded = { fg = palette.green },
	DiffRemoved = { fg = palette.red },
	DiffChanged = { fg = palette.yellow },
	DiffFile = { fg = palette.red, bold = true },
	DiffLine = { fg = palette.blue },
	DiffIndexLine = { fg = palette.overlay1 },

	GitSignsAdd = { fg = palette.green },
	GitSignsChange = { fg = palette.yellow },
	GitSignsDelete = { fg = palette.red },
}

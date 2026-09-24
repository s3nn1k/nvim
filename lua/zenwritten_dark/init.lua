---@diagnostic disable: undefined-global
local lush = require("lush")
local hsluv = lush.hsluv
local util = require("zenbones.util")
local generator = require("zenbones.specs")

local palette = util.palette_extend({
	bg = hsluv(0, 0, 9),
	fg = hsluv "#d4d4d4",
}, "dark")

local specs = generator.generate(palette, "dark", generator.get_global_config("zenwritten", "dark"))

local function spec_fg(name)
	local group = specs[name]
	return group and group.fg or specs.Normal.fg
end

return lush.extends({ specs }).with(function()
	return {
		Normal { fg = specs.Normal.fg, bg = "#14191f" },
		NormalNC { fg = spec_fg("NormalNC"), bg = "#14191f" },
		MsgArea { fg = spec_fg("MsgArea"), bg = "#14191f" },
		EndOfBuffer { fg = spec_fg("EndOfBuffer"), bg = "#14191f" },
		LineNr { fg = "#7d7d7d", bg = "#14191f" },
		SignColumn { fg = spec_fg("SignColumn"), bg = "#14191f" },
		FoldColumn { fg = spec_fg("FoldColumn"), bg = "#14191f" },
		Folded { fg = spec_fg("Folded"), bg = "#1e242c" },
		CursorLine { fg = spec_fg("CursorLine"), bg = "#1e242c" },
		CursorColumn { fg = spec_fg("CursorColumn"), bg = "#1e242c" },
		ColorColumn { fg = spec_fg("ColorColumn"), bg = "#1e242c" },
		String { fg = "#b5b5b5" },
		Constant { fg = "#b5b5b5" },
		Number { fg = "#b5b5b5" },
		Type { fg = "#adadad" },
		Identifier { fg = "#c2c2c2" },
		Comment { fg = "#8f8f8f" },
		NonText { fg = "#757575" },
		CursorLineNr { fg = "#d4d4d4", bg = "#1e242c" },
	}
end)

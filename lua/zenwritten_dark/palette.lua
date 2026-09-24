local lush = require("lush")
local hsluv = lush.hsluv
local util = require("zenbones.util")

return {
	dark = util.palette_extend({
		bg = hsluv(0, 0, 9),
		fg = hsluv "#d4d4d4",
	}, "dark"),
}

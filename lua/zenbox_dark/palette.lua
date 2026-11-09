local palette = {
	fg = "#d4d4d4",
	fg_dim = "#bdae93",
	comment = "#928374",
	punct = "#ebdbb2",

	red = "#fb4934",
	orange = "#fe8019",
	yellow = "#fabd2f",
	green = "#b8bb26",
	cyan = "#8ec07c",
	blue = "#83a598",
	purple = "#d3869b",
	member = "#d8bb7e",

	bg = "#15191f",
	lift = "#3c3836",
	selection = "#665c54",
	overlay0 = "#504945",
	overlay1 = "#7c6f64",

	diff_add = "#41512f",
	diff_change = "#45403d",
	diff_delete = "#533535",
	diff_text = "#4a412f",
}

local function bright(hex)
	local channel = function(value)
		return math.floor(value + (255 - value) * 0.25)
	end
	local r = channel(tonumber(hex:sub(2, 3), 16))
	local g = channel(tonumber(hex:sub(4, 5), 16))
	local b = channel(tonumber(hex:sub(6, 7), 16))
	return string.format("#%02x%02x%02x", r, g, b)
end

palette.terminal = {
	palette.bg,
	palette.red,
	palette.green,
	palette.yellow,
	palette.blue,
	palette.purple,
	palette.cyan,
	palette.fg_dim,
	palette.overlay1,
	bright(palette.red),
	bright(palette.green),
	bright(palette.yellow),
	bright(palette.blue),
	bright(palette.purple),
	bright(palette.cyan),
	palette.fg,
}

return palette

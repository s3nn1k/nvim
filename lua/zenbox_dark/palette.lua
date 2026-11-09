local palette = {
	fg = "#d4d4d4",
	fg_dim = "#b5b5b5",
	comment = "#969696",

	red = "#e88a76",
	orange = "#f0a26e",
	yellow = "#e5c07b",
	green = "#98c379",
	cyan = "#8cd0d3",
	blue = "#8ba8e3",
	purple = "#c99ad9",
	member = "#d8bb7e",

	bg = "#15191f",
	lift = "#1b2027",
	selection = "#2a3547",
	overlay0 = "#4a5261",
	overlay1 = "#5b6472",

	diff_add = "#202c1e",
	diff_change = "#232631",
	diff_delete = "#2e201e",
	diff_text = "#2b3a27",
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

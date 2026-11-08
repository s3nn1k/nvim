local toggle_context

local spec = {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		mode = "topline",
		max_lines = 4,
		multiline_threshold = 1,
		trim_scope = "outer",
		min_window_height = 20,
	},
	keys = {
		{ "<leader>c", toggle_context, desc = "Toggle treesitter context" },
	},
}

toggle_context = function()
	local context = require("treesitter-context")
	context.toggle()
	print("Treesitter context: " .. (context.enabled() and "ON" or "OFF"))
end

return spec

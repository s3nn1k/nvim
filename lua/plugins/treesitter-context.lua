return {
	"nvim-treesitter/nvim-treesitter-context",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		mode = "topline",
		max_lines = 4,
		multiline_threshold = 1,
		trim_scope = "outer",
		min_window_height = 20,
	},
	keys = {
		{
			"<leader>tc",
			function()
				local ctx = require("treesitter-context")
				ctx.toggle()
				print("Treesitter context: " .. (ctx.enabled() and "ON" or "OFF"))
			end,
			desc = require("package.keymaps").desc("Toggle treesitter context"),
		},
	},
}

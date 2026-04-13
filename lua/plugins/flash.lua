local km = require("package.keymaps")

return {
	"folke/flash.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"s",
			mode = { "n", "x", "o" },
			function()
				require("flash").jump()
			end,
			desc = km.desc("Flash jump"),
		},
		{
			"S",
			mode = { "n", "o" },
			function()
				require("flash").treesitter()
			end,
			desc = km.desc("Flash treesitter"),
		},
		{
			"r",
			mode = "o",
			function()
				require("flash").remote()
			end,
			desc = km.desc("Flash remote"),
		},
		{
			"R",
			mode = { "o", "x" },
			function()
				require("flash").treesitter_search()
			end,
			desc = km.desc("Flash treesitter search"),
		},
	},
}

return {
	"linrongbin16/gitlinker.nvim",
	event = "VeryLazy",
	opts = {},
	keys = {
		{
			"<leader>gl",
			"<cmd>GitLink<CR>",
			mode = { "n", "v" },
			desc = require("package.keymaps").desc("Git: copy link to clipboard"),
		},
		{
			"<leader>gL",
			"<cmd>GitLink!<CR>",
			mode = { "n", "v" },
			desc = require("package.keymaps").desc("Git: open link in browser"),
		},
	},
}

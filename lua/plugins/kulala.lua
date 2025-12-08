return {
	"mistweaverco/kulala.nvim", -- also provides formatter for .http and .rest
	ft = { "http", "rest" },
	opts = {
		global_keymaps = false,
		global_keymaps_prefix = "",
	},
	keys = {
		{
			"<leader>x",
			function()
				require("kulala").run()
			end,
			desc = "Execute current HTTP request",
			mode = { "n", "v" },
		},
	},
}

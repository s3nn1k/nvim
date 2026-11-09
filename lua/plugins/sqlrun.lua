return {
	"s3nn1k/sqlrun",
	version = "*",
	dependencies = { "nvim-telescope/telescope.nvim" },
	ft = "sql",
	keys = {
		{
			"<leader>x",
			function()
				require("sqlrun").run()
			end,
			mode = { "n", "v" },
			ft = "sql",
			desc = "sqlrun: execute SQL",
		},
	},
	opts = {
		result_keymaps = { close = "q", save = "<C-s>" },
	},
}

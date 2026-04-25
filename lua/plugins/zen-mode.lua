return {
	"folke/zen-mode.nvim",
	dependencies = { "folke/twilight.nvim" },
	cmd = "ZenMode",
	opts = {
		window = {
			backdrop = 0.95,
			width = 120,
			height = 1,
			options = {
				signcolumn = "no",
				number = false,
				relativenumber = false,
				cursorline = false,
				list = false,
			},
		},
		plugins = {
			options = { laststatus = 0, showcmd = false },
			gitsigns = { enabled = false },
			tmux = { enabled = false },
			twilight = { enabled = true },
		},
	},
	keys = {
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
	},
}

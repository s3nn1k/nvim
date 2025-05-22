-- Small plugins that make neovim look better
return {
	-- Simple but yet beautiful icons
	"nvim-tree/nvim-web-devicons",
	-- Bufferline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		config = function()
			require("bufferline").setup({
				options = {
					indicator = { style = "none" },
					diagnostics = "nvim-lsp",
					separator_style = { "|", "|" },
				},

				highlights = {
					buffer_selected = {
						italic = false,
					},
				},
			})
		end,
	},
	-- Fidget
	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				window = {
					winblend = 0,
					x_padding = 2,
				},
			},
		},
	},
	-- Gitsigns
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({})
		end,
	},
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
}

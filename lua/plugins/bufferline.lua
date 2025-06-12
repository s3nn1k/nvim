return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local line = require("bufferline")

		line.setup({
			options = {
				style_preset = line.style_preset.no_italic,
				mode = "buffers",
				themable = true,
				tab_size = 22,
				separator_style = { "│", "│" },
				diagnostics = "nvim_lsp",
				indicator = {
					style = "none",
				},
				offsets = {
					{
						filetype = "neo-tree",
						text = "Project Neo-Tree",
						highlight = "Directory",
						text_align = "center",
						separator = true,
					},
				},
			},
		})
	end,
}

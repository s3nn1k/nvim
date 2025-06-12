return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				section_separators = { left = "", right = "" },
				component_separators = { left = "│", right = "│" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 0 } },
				lualine_x = { "lsp_status", "encoding", "fileformat" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}

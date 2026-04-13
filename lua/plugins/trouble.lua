return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	config = function()
		require("trouble").setup({
			focus = true,
		})

		local km = require("package.keymaps")
		local base_opts = { noremap = true, silent = true }
		local function opts(desc, extra)
			return km.opts(base_opts, desc, extra)
		end
		local map = vim.keymap.set

		-- current buffer diagnostics
		map(
			"n",
			"<leader>td",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			opts("Trouble: document diagnostics")
		)
		-- workspace diagnostics
		map("n", "<leader>tD", "<cmd>Trouble diagnostics toggle<cr>", opts("Trouble: workspace diagnostics"))
		-- quickfix list
		map("n", "<leader>tq", "<cmd>Trouble qflist toggle<cr>", opts("Trouble: quickfix"))
	end,
}

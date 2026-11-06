return {
	"s3nn1k/nrdr",
	dependencies = { "nvim-telescope/telescope.nvim" },
	init = function()
		local keymaps = require("package.keymaps")

		vim.keymap.set("n", "<leader>hc", function()
			require("nrdr").add_line(vim.v.count)
		end, {
			desc = keymaps.desc("Add review remark for cursor line"),
		})
		vim.keymap.set("v", "<leader>hc", function()
			require("nrdr").add_range(vim.fn.line("."), vim.fn.line("v"))
		end, {
			desc = keymaps.desc("Add review remark for selection"),
		})
		vim.keymap.set("n", "<leader>hb", function()
			require("nrdr").pick()
		end, {
			desc = keymaps.desc("Browse review remarks"),
		})
		vim.keymap.set("n", "<leader>hs", function()
			require("nrdr").send()
		end, {
			desc = keymaps.desc("Send review remarks to herdr agent"),
		})
	end,
}

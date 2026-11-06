return {
	dir = vim.fn.expand("~/projects/personal/pi-remarks"),
	dependencies = { "nvim-telescope/telescope.nvim" },
	init = function()
		local keymaps = require("package.keymaps")

		vim.keymap.set("n", "<leader>pc", function()
			require("pi-remarks").add_line(vim.v.count)
		end, {
			desc = keymaps.desc("Add review remark for cursor line"),
		})
		vim.keymap.set("v", "<leader>pc", function()
			require("pi-remarks").add_range(vim.fn.line("'<"), vim.fn.line("'>"))
		end, {
			desc = keymaps.desc("Add review remark for selection"),
		})
		vim.keymap.set("n", "<leader>pb", function()
			require("pi-remarks").pick()
		end, {
			desc = keymaps.desc("Browse review remarks"),
		})
		vim.keymap.set("n", "<leader>ps", function()
			require("pi-remarks").send()
		end, {
			desc = keymaps.desc("Send review remarks to pi agent"),
		})
	end,
}

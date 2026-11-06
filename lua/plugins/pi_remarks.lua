return {
	dir = vim.fn.expand("~/projects/personal/pi-remarks"),
	init = function()
		local keymaps = require("package.keymaps")

		vim.keymap.set({ "n", "v" }, "<leader>ma", ":PiRemarksAdd<CR>", {
			desc = keymaps.desc("Add review remark for line or selection"),
		})
		vim.keymap.set("n", "<leader>ml", ":PiRemarks<CR>", {
			desc = keymaps.desc("Open review remarks list"),
		})
		vim.keymap.set("n", "<leader>ms", ":PiRemarksSend<CR>", {
			desc = keymaps.desc("Send review remarks to pi agent"),
		})
	end,
}

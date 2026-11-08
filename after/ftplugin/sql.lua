vim.keymap.set({ "n", "v" }, "<leader>x", function()
	require("sqlrun").run()
end, { buffer = true, desc = "sqlrun: execute SQL" })

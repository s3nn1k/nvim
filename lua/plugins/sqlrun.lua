return {
	"s3nn1k/sqlrun",
	dependencies = { "nvim-telescope/telescope.nvim" },
	ft = { "sql" },
	init = function()
		local keymap_group = vim.api.nvim_create_augroup("SqlrunSqlKeymap", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = keymap_group,
			pattern = "sql",
			callback = function()
				vim.keymap.set({ "n", "v" }, "<leader>x", function()
					require("sqlrun").run()
				end, {
					buffer = true,
					desc = require("package.keymaps").desc("Execute current SQL query"),
				})
			end,
		})

		local sweep_group = vim.api.nvim_create_augroup("SqlrunForwardSweep", { clear = true })
		vim.api.nvim_create_autocmd("VimEnter", {
			group = sweep_group,
			callback = function()
				local registry = vim.fn.stdpath("cache") .. "/sqlrun-forward"
				local ok_dir, iterator = pcall(vim.fs.dir, registry)
				if not ok_dir or iterator == nil then
					return
				end
				for _ in iterator do
					require("sqlrun").sweep()
					return
				end
			end,
		})
		vim.api.nvim_create_autocmd("VimLeavePre", {
			group = sweep_group,
			callback = function()
				local ok, sqlrun = pcall(require, "sqlrun")
				if ok then
					sqlrun.shutdown()
				end
			end,
		})
	end,
}

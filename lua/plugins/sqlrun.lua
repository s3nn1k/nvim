return {
	"s3nn1k/sqlrun",
	dependencies = { "nvim-telescope/telescope.nvim" },
	ft = { "sql" },
	init = function()
		local group = vim.api.nvim_create_augroup("SqlrunForwardSweep", { clear = true })
		vim.api.nvim_create_autocmd("VimEnter", {
			group = group,
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
			group = group,
			callback = function()
				local ok, sqlrun = pcall(require, "sqlrun")
				if ok then
					sqlrun.shutdown()
				end
			end,
		})
	end,
	keys = {
		{
			"<leader>X",
			function()
				require("sqlrun").run()
			end,
			desc = require("package.keymaps").desc("Execute current SQL query"),
			mode = { "n", "v" },
		},
		{
			"<leader>Xs",
			function()
				require("sqlrun").pick_service()
			end,
			desc = require("package.keymaps").desc("Switch SQL connection"),
		},
	},
}

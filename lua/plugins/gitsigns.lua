return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local km = require("package.keymaps")
		local base_opts = { noremap = true, silent = true }
		local function opts(desc, bufnr)
			return km.opts(vim.tbl_extend("force", base_opts, { buffer = bufnr }), desc)
		end

		require("gitsigns").setup({
			on_attach = function(bufnr)
				local gs = require("gitsigns")
				local map = vim.keymap.set

				map({ "n", "v" }, "<leader>gs", gs.stage_hunk, opts("Stage hunk", bufnr))
				map({ "n", "v" }, "<leader>gr", gs.reset_hunk, opts("Reset hunk", bufnr))
				map("n", "<leader>ga", gs.stage_buffer, opts("Stage buffer", bufnr))
				map("n", "<leader>gb", gs.blame_line, opts("Blame line", bufnr))
				map("n", "<leader>gd", gs.diffthis, opts("Diff this", bufnr))
			end,
		})
	end,
}

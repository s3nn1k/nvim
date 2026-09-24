return {
	"zenbones-theme/zenbones.nvim",
	dependencies = { "rktjmp/lush.nvim" },
	priority = 1000,
	config = function()
		vim.cmd("colorscheme zenwritten_dark")

		local exact = {
			Normal = { bg = "#14191f" },
			NormalNC = { link = "Normal" },
			MsgArea = { link = "Normal" },
			EndOfBuffer = { bg = "#14191f" },
			LineNr = { bg = "#14191f" },
			SignColumn = { bg = "#14191f" },
			FoldColumn = { bg = "#14191f" },
			Folded = { bg = "#1e242c" },
			CursorLine = { bg = "#1e242c" },
			CursorColumn = { link = "CursorLine" },
			ColorColumn = { link = "CursorLine" },
		}
		for group, opts in pairs(exact) do
			vim.api.nvim_set_hl(0, group, opts)
		end
	end,
}

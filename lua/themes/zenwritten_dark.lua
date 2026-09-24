return {
	"zenbones-theme/zenbones.nvim",
	dependencies = { "rktjmp/lush.nvim" },
	priority = 1000,
	config = function()
		if require("themes").active_name() == "zenwritten_dark" then
			vim.cmd("colorscheme zenwritten_dark")
		end
	end,
}

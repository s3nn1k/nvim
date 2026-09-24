if vim.g.colors_name then
	vim.api.nvim_command("highlight clear")
end

vim.o.background = "dark"
vim.g.colors_name = "zenwritten_dark"

require("zenbones.util").apply_colorscheme()

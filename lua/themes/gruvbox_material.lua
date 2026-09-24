return {
	"sainnhe/gruvbox-material",
	priority = 1000,
	config = function()
		vim.g.gruvbox_material_background = "soft"
		vim.g.gruvbox_material_transparent_background = 1
		if require("themes").active_name() == "gruvbox-material" then
			vim.cmd("colorscheme gruvbox-material")
		end
	end,
}

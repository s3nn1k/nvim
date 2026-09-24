local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Theme
	require("themes").spec,

	-- Plugins
	{ { import = "plugins" } },

	-- Performance
	performance = {
		rtp = {
			disabled_plugins = {
				"tutor",
				"gzip",
				"tar",
				"tarPlugin",
				"tohtml",
				"zip",
				"zipPlugin",
				"rplugin",
				"getscript",
				"getscriptPlugin",
				"logipat",
				"rrhelper",
			},
		},
	},
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		enabled = true,
		notify = false,
	},
})

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<C-p>",
			function()
				-- Dictionary view: show all described custom keymaps (not just <leader>)
				require("which-key").show({ global = true })
			end,
			desc = require("package.keymaps").desc("Keymap dictionary (all modified)"),
		},
	},
	config = function()
		local wk = require("which-key")
		local km = require("package.keymaps")
		local win_w = math.max(20, math.floor(vim.o.columns * 0.25))
		local win_h = math.max(4, math.floor(vim.o.lines * 0.35))
		local bottom_offset = 2 -- keep space for statusline (lualine) + safety
		local right_offset = 1
		wk.setup({
			triggers = {},
			show_help = false,
			show_keys = false,
			notify = false,
			keys = {
				-- These must NOT be valid keymaps, otherwise which-key will execute them.
				-- Using plain j/k works well for a dictionary view.
				scroll_down = "j",
				scroll_up = "k",
			},
			icons = {
				-- Keep the icon column, but don't auto-generate Nerd Font icons.
				-- This avoids "missing glyph" squares when your font can't render them.
				mappings = false,
				rules = false,
			},
			plugins = {
				marks = false,
				registers = false,
				spelling = { enabled = false },
				presets = {
					operators = false,
					motions = false,
					text_objects = false,
					windows = false,
					nav = false,
					z = false,
					g = false,
				},
			},
			replace = {
				desc = {
					{ km.PATTERN, "" },
				},
			},
			filter = function(mapping)
				if mapping.group then
					return true
				end
				return km.is_cfg(mapping.desc)
			end,
			win = {
				border = "single",
				padding = { 1, 1 },
				title = "Dictionary",
				title_pos = "center",
				width = win_w,
				height = win_h,
				row = math.max(0, vim.o.lines - win_h - bottom_offset),
				col = vim.o.columns - win_w - right_offset,
			},
		})

		wk.add({
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>j", group = "jump" },
			{ "<leader>s", group = "split" },
			{ "<leader>t", group = "toggle" },
			{ "<leader>c", group = "close" },
			{ "<leader>x", group = "http" },
		})
	end,
}

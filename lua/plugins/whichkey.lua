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
		-- Use relative dimensions so the popup adapts to terminal resizes.
		-- (Fixed numbers are calculated only once at startup.)
		local bottom_offset = 2 -- keep space for statusline (lualine) + safety
		local right_offset = 1
		wk.setup({
			triggers = {},
			show_keys = true,
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
				-- clamp to at least 50x4, otherwise use a percentage of the editor size
				width = { min = 50, max = 0.25 },
				height = { min = 4, max = 0.35 },
				-- bottom-right with a small safety margin
				row = -bottom_offset,
				col = -right_offset,
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

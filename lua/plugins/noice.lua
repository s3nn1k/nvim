return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		{
			"rcarriga/nvim-notify",
			opts = {
				timeout = 3000,
				stages = "static",
				top_down = false,
				fps = 60,
				render = "compact",
				icons = {
					ERROR = " ",
					WARN = " ",
					INFO = " ",
					DEBUG = " ",
					TRACE = " ",
				},
			},
		},
	},

	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline_popup",

			format = {
				cmdline = { pattern = "^:", icon = "" },
				search_down = { kind = "search", pattern = "^/", icon = " " },
				search_up = { kind = "search", pattern = "^%?", icon = " " },
			},
		},

		notify = {
			enabled = true,
			view = "notify",
		},

		messages = {
			enabled = true,
			view = "notify",
			view_error = "notify",
			view_warn = "notify",
			view_history = "messages",
		},

		popupmenu = { enabled = false },

		lsp = {
			progress = { enabled = false },
			hover = { enabled = false },
			signature = { enabled = false },
			message = { enabled = false },
		},

		presets = {
			bottom_search = false,
			command_palette = false,
		},
	},
}

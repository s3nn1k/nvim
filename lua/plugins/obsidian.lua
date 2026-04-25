return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	ft = "markdown",
	cmd = "Obsidian",
	keys = {
		{
			"<leader>on",
			"<cmd>Obsidian new<cr>",
			desc = require("package.keymaps").desc("Obsidian: new note"),
		},
	},
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		workspaces = {
			{ name = "main", path = "~/vaults/main" },
		},

		notes_subdir = "inbox",
		new_notes_location = "notes_subdir",

		-- Collisions: existing file is opened (not overwritten); body is preserved.
		note_id_func = function(title)
			return title or os.date("%Y-%m-%d-%H%M%S")
		end,
		note_path_func = function(spec)
			return (spec.dir / tostring(spec.id)):with_suffix(".md")
		end,

		legacy_commands = false,

		ui = { enable = false },
		footer = { enabled = false },
		statusline = { enabled = false },
		frontmatter = { enabled = false },
		templates = { enabled = false },
		daily_notes = { enabled = false },
		unique_note = { enabled = false },
		checkbox = { enabled = false },
		slides = { enabled = false },
		comment = { enabled = false },
		sync = { enabled = false },

		completion = {
			nvim_cmp = false,
			blink = false,
			create_new = false,
		},

		picker = { name = nil },
		callbacks = {},
		link = { auto_update = false },
	},
}

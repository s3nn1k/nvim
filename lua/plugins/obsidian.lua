local note = require("package.obsidian_note")

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
		{
			"<leader>ot",
			"<cmd>Obsidian tags<cr>",
			desc = require("package.keymaps").desc("Obsidian: vault tags"),
		},
		{
			"<leader>op",
			"<cmd>Obsidian new_from_template<cr>",
			desc = require("package.keymaps").desc("Obsidian: new note from preset"),
		},
	},
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
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
		frontmatter = {
			enabled = true,
			func = note.frontmatter,
			sort = { "id", "aliases", "tags", "created", "updated" },
		},
		templates = {
			enabled = true,
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},
		daily_notes = { enabled = false },
		unique_note = { enabled = false },
		checkbox = { enabled = false },
		slides = { enabled = false },
		comment = { enabled = false },
		sync = { enabled = false },

		picker = { name = "telescope.nvim" },
		callbacks = {},
		link = { auto_update = false },
	},
}

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
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {
		workspaces = {
			{ name = "main", path = "~/vaults/main" },
		},

		notes_subdir = "inbox",
		new_notes_location = "notes_subdir",

		-- Collisions: existing file is opened (not overwritten); body is preserved.
		note_id_func = function(title)
			return title or os.date("%Y-%m-%d-%H:%M:%S")
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
			func = function(note)
				local today = os.date("%Y-%m-%d %H:%M")
				local out = {
					id = note.id,
					aliases = note.aliases,
					tags = note.tags,
					created = (note.metadata and note.metadata.created) or today,
					updated = today,
				}
				if note.metadata then
					for k, v in pairs(note.metadata) do
						if k ~= "created" and k ~= "updated" then
							out[k] = v
						end
					end
				end
				return out
			end,
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

		completion = {
			nvim_cmp = true,
			blink = false,
			create_new = true,
		},

		picker = { name = nil },
		callbacks = {},
		link = { auto_update = false },
	},
}

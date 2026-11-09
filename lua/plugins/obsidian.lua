local frontmatter
local notify_workspace
local note_id
local note_path

local function new_note_from_template()
	local source_path = Obsidian.workspace.root
	require("obsidian.actions").new_from_template(nil, nil, function(new_note)
		new_note:open({ sync = true })
	end, { source_path = source_path })
end

local spec = {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	ft = "markdown",
	cmd = "Obsidian",
	keys = {
		{ "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian: new note" },
		{ "<leader>ot", "<cmd>Obsidian tags<cr>", desc = "Obsidian: vault tags" },
		{ "<leader>op", new_note_from_template, desc = "Obsidian: new note from preset" },
		{ "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Obsidian: switch workspace" },
	},
	init = function()
		vim.g.obsidian_default_keymap = false
		vim.api.nvim_create_autocmd("User", {
			pattern = "ObsidianWorkpspaceSet", -- опечатка в паттерне самого плагина
			callback = notify_workspace,
		})
	end,
}

function spec.opts()
	return {
		workspaces = {
			{ name = "personal", path = "~/vaults/personal" },
			{ name = "work", path = "~/vaults/work" },
		},

		notes_subdir = "inbox",
		new_notes_location = "notes_subdir",

		note_id_func = note_id,
		note_path_func = note_path,

		legacy_commands = false,

		ui = { enable = false },
		footer = { enabled = false },
		statusline = { enabled = false },
		daily_notes = { enabled = false },
		unique_note = { enabled = false },
		checkbox = { enabled = false },
		slides = { enabled = false },
		comment = { enabled = false },
		sync = { enabled = false },

		frontmatter = {
			enabled = true,
			func = frontmatter,
			sort = { "id", "aliases", "tags", "created", "updated" },
		},
		templates = {
			enabled = true,
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
		},

		picker = {
			name = "telescope.nvim",
			tag_mappings = {
				tag_note = "<C-x>",
				insert_tag = "<C-l>",
			},
		},

		link = { auto_update = false },
	}
end

frontmatter = function(note)
	local today = os.date("%Y-%m-%d %H:%M")
	local out = {
		id = note.id,
		aliases = note.aliases,
		tags = note.tags,
		created = (note.metadata and note.metadata.created) or today,
		updated = today,
	}
	if note.metadata then
		for key, value in pairs(note.metadata) do
			if key ~= "created" and key ~= "updated" then
				out[key] = value
			end
		end
	end
	return out
end

notify_workspace = function(event)
	vim.notify("Obsidian: " .. event.data.workspace.name)
end

note_id = function(title)
	return title or os.date("%Y-%m-%d-%H%M%S")
end

note_path = function(path_spec)
	return (path_spec.dir / tostring(path_spec.id)):with_suffix(".md")
end

return spec

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/obsidian.nvim")

local obsidian = require("obsidian")
local picker = require("obsidian.picker")
local lsp = require("obsidian.lsp")
local Workspace = obsidian.Workspace
local plugin_spec = dofile(vim.fn.getcwd() .. "/lua/plugins/obsidian.lua")

local tmp_root
local vaults
local original_input
local original_find_files
local original_lsp_start
local function write_file(path, lines)
	vim.fn.mkdir(vim.fs.dirname(path), "p")
	vim.fn.writefile(lines, path)
	return path
end

local function template_mapping()
	for _, mapping in ipairs(plugin_spec.keys) do
		if mapping[1] == "<leader>op" then
			return mapping[2]
		end
	end
	error("template mapping not found")
end

local function create_vault(name)
	local root = tmp_root .. "/" .. name
	vim.fn.mkdir(root .. "/.obsidian", "p")
	write_file(root .. "/templates/meeting.md", { "from template" })
	return vim.uv.fs_realpath(root) or root
end

local function run_template_creation(changes_workspace)
	local template_path = vaults.b .. "/templates/meeting.md"

	picker.find_files = function(options)
		assert.are.same(vim.fs.normalize(vaults.b .. "/templates"), vim.fs.normalize(tostring(options.dir)))
		if changes_workspace then
			Workspace.set("a")
		end
		options.callback({ template_path })
	end
	vim.fn.input = function()
		return "from-template"
	end

	template_mapping()()
	local created_path = vim.fs.normalize(vim.api.nvim_buf_get_name(0))
	assert.is_true(vim.startswith(created_path, vaults.b .. "/inbox/"))
	assert.are.equal(1, vim.fn.filereadable(created_path))
	assert.is_true(vim.tbl_contains(vim.fn.readfile(created_path), "from template"))
end

describe("Obsidian template workspace", function()
	before_each(function()
		original_lsp_start = lsp.start
		lsp.start = function() end
		tmp_root = vim.fn.tempname()
		vim.fn.mkdir(tmp_root, "p")
		tmp_root = vim.uv.fs_realpath(tmp_root) or tmp_root
		vaults = { a = create_vault("a"), b = create_vault("b") }

		obsidian.setup({
			workspaces = {
				{ name = "b", path = vaults.b },
				{ name = "a", path = vaults.a },
			},
			legacy_commands = false,
			notes_subdir = "inbox",
			new_notes_location = "notes_subdir",
			templates = { enabled = true, folder = "templates" },
			picker = { name = "telescope.nvim" },
			ui = { enable = false },
		})
		Workspace.set("b")
		original_input = vim.fn.input
		original_find_files = picker.find_files
	end)

	after_each(function()
		vim.fn.input = original_input
		picker.find_files = original_find_files
		lsp.start = original_lsp_start
		require("obsidian.cache").shutdown()
		vim.cmd("silent! %bwipeout!")
		vim.fn.delete(tmp_root, "rf")
	end)

	it("keeps the selected workspace when an open note changes it in the picker", function()
		local open_note = write_file(vaults.a .. "/inbox/open.md", { "open" })
		vim.cmd("edit! " .. vim.fn.fnameescape(open_note))
		Workspace.set("b")

		run_template_creation(true)
	end)

	it("opens the note in the unchanged workspace", function()
		run_template_creation(false)
	end)
end)

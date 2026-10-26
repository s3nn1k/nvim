local smart_goto = require("package.smart_goto")

local tmp_root
local notify_calls
local picked
local originals

local function write_file(rel_path, lines)
	local full = tmp_root .. "/" .. rel_path
	vim.fn.mkdir(vim.fs.dirname(full), "p")
	vim.fn.writefile(lines or { "test" }, full)
	return full
end

local function open_with_word(rel_path, line)
	vim.cmd("edit! " .. vim.fn.fnameescape(write_file(rel_path)))
	vim.api.nvim_buf_set_lines(0, 0, -1, false, { line })
	vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

local function current_file()
	return vim.fs.normalize(vim.api.nvim_buf_get_name(0))
end

local function stub_notify()
	vim.notify = function(msg, level)
		table.insert(notify_calls, { msg = msg, level = level })
	end
end

local function stub_lsp(result)
	vim.lsp.util.make_position_params = function()
		return {}
	end
	vim.lsp.buf_request_sync = function()
		return result and { [1] = { result = result } } or nil
	end
end

local function capture_picker()
	return function(text, cwd)
		picked = { text = text, cwd = cwd }
	end
end

describe("smart_goto fallback", function()
	before_each(function()
		notify_calls = {}
		picked = nil
		originals = {
			params = vim.lsp.util.make_position_params,
			request = vim.lsp.buf_request_sync,
			definition = vim.lsp.buf.definition,
			notify = vim.notify,
		}
		tmp_root = vim.fs.normalize(vim.fn.tempname())
		vim.fn.mkdir(tmp_root, "p")
		tmp_root = vim.uv.fs_realpath(tmp_root) or tmp_root
		vim.cmd("cd " .. vim.fn.fnameescape(tmp_root))
		stub_lsp(nil)
		stub_notify()
	end)

	after_each(function()
		vim.lsp.util.make_position_params = originals.params
		vim.lsp.buf_request_sync = originals.request
		vim.lsp.buf.definition = originals.definition
		vim.notify = originals.notify
		vim.fn.delete(tmp_root, "rf")
	end)

	describe("link forms", function()
		it("resolves wiki link against buffer dir", function()
			local note = write_file("note.md")
			open_with_word("outer.md", "[[note]]")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(note), current_file())
		end)

		it("cuts alias and anchor from wiki link", function()
			local note = write_file("note.md")
			open_with_word("outer.md", "[[note#section|Alias]]")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(note), current_file())
		end)

		it("decodes percent escapes and cuts anchor in markdown link", function()
			local note = write_file("my note.md")
			open_with_word("outer.md", "(my%20note.md#head)")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(note), current_file())
		end)

		it("cuts anchor in bare angle-wrapped link", function()
			local page = write_file("sub/page.md")
			open_with_word("outer.md", "<sub/page#head>")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(page), current_file())
		end)

		it("resolves bare bracket-wrapped link", function()
			local page = write_file("sub/page.md")
			open_with_word("outer.md", "[sub/page.md]")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(page), current_file())
		end)

		it("appends .md to unwrapped word", function()
			local note = write_file("note2.md")
			open_with_word("outer.md", "note2")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(note), current_file())
		end)

		it("keeps invalid percent escape as is", function()
			local weird = write_file("%zz.md")
			open_with_word("outer.md", "(%zz.md)")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(weird), current_file())
		end)

		it("notifies when nothing can be extracted from empty word", function()
			open_with_word("outer.md", "")
			smart_goto.smart_goto({})
			assert.same(1, #notify_calls)
			assert.same(vim.log.levels.WARN, notify_calls[1].level)
			assert.is_truthy(notify_calls[1].msg:find("^Can't extract path"))
		end)
	end)

	describe("path resolution", function()
		it("uses absolute link as is", function()
			local target = write_file("elsewhere/deep.md")
			open_with_word("notes/outer.md", "(" .. target .. ")")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(target), current_file())
		end)

		it("searches buffer dir before cwd", function()
			local near = write_file("notes/note.md")
			write_file("note.md")
			open_with_word("notes/outer.md", "[[note]]")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(near), current_file())
		end)

		it("searches cwd after buffer dir", function()
			local far = write_file("note.md")
			open_with_word("notes/outer.md", "[[note]]")
			smart_goto.smart_goto({})
			assert.same(vim.fs.normalize(far), current_file())
		end)

		it("searches vault root last", function()
			local vault_note = write_file("vault/v.md")
			open_with_word("notes/outer.md", "[[v]]")
			smart_goto.smart_goto({
				vault_root = function()
					return tmp_root .. "/vault"
				end,
			})
			assert.same(vim.fs.normalize(vault_note), current_file())
		end)
	end)

	describe("fallback picker", function()
		it("passes link and vault root to find_files", function()
			open_with_word("notes/outer.md", "[[gone]]")
			smart_goto.smart_goto({
				vault_root = function()
					return tmp_root .. "/vault"
				end,
				find_files = capture_picker(),
			})
			assert.are.same({ text = "gone", cwd = tmp_root .. "/vault" }, picked)
		end)

		it("picker cwd falls back to buffer dir without vault", function()
			open_with_word("notes/outer.md", "[[gone]]")
			smart_goto.smart_goto({ find_files = capture_picker() })
			assert.are.same({ text = "gone", cwd = vim.fs.normalize(tmp_root .. "/notes") }, picked)
		end)

		it("ignores non-string vault root", function()
			open_with_word("notes/outer.md", "[[gone]]")
			smart_goto.smart_goto({
				vault_root = function()
					return 42
				end,
				find_files = capture_picker(),
			})
			assert.are.same({ text = "gone", cwd = vim.fs.normalize(tmp_root .. "/notes") }, picked)
		end)

		it("notifies when nothing found and no picker given", function()
			open_with_word("notes/outer.md", "[[gone]]")
			smart_goto.smart_goto({})
			assert.same(1, #notify_calls)
			assert.same("File not found: gone", notify_calls[1].msg)
		end)
	end)

	describe("lsp branch", function()
		it("jumps to definition when lsp returns a result", function()
			stub_lsp({ { targetUri = "file:///elsewhere.md" } })
			local defined = false
			vim.lsp.buf.definition = function()
				defined = true
			end
			open_with_word("outer.md", "[[note]]")
			smart_goto.smart_goto({})
			assert.is_true(defined)
			assert.same(vim.fs.normalize(tmp_root .. "/outer.md"), current_file())
		end)

		it("falls through when lsp result is vim.NIL", function()
			stub_lsp(vim.NIL)
			open_with_word("outer.md", "[[note]]")
			smart_goto.smart_goto({})
			assert.same(1, #notify_calls)
			assert.same("File not found: note", notify_calls[1].msg)
		end)
	end)
end)

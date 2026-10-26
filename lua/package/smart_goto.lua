local M = {}

local function decode_percent_escapes(text)
	return (text:gsub("%%(%x%x)", function(hex)
		return string.char(tonumber(hex, 16))
	end))
end

local function strip_bare_wrapping(text)
	text = text:gsub("^%(", ""):gsub("%)$", "")
	text = text:gsub("^%[", ""):gsub("%]$", "")
	text = text:gsub("^<", ""):gsub(">$", "")
	return text
end

local function extract_link(word)
	local link
	if word:find("[[", 1, true) then
		link = word:match("%[%[([^%]|#]*)")
	else
		link = word:match("%(([^)]*)%)") or strip_bare_wrapping(word)
	end
	link = link:gsub("#.*$", "")
	return vim.trim(decode_percent_escapes(link))
end

local function append_unique(list, value)
	if value and value ~= "" and not vim.list_contains(list, value) then
		list[#list + 1] = value
	end
end

function M.smart_goto(opts)
	opts = opts or {}

	local params = vim.lsp.util.make_position_params(0, "utf-16")
	local results = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 1000)

	local has_def = false
	if results then
		for _, res in pairs(results) do
			if type(res.result) == "table" and next(res.result) ~= nil then
				has_def = true
				break
			end
		end
	end

	if has_def then
		vim.lsp.buf.definition()
		return
	end

	local word = vim.fn.expand("<cWORD>")
	local link = extract_link(word)
	if link == "" then
		vim.notify("Can't extract path from: " .. word, vim.log.levels.WARN)
		return
	end

	local buffer_name = vim.api.nvim_buf_get_name(0)
	local buffer_dir = buffer_name ~= "" and vim.fn.fnamemodify(buffer_name, ":p:h") or nil
	local vault_root = opts.vault_root and opts.vault_root() or nil
	if type(vault_root) ~= "string" then
		vault_root = nil
	end

	local bases = {}
	if link:sub(1, 1) ~= "/" then
		append_unique(bases, buffer_dir)
		append_unique(bases, vim.fn.getcwd())
		append_unique(bases, vault_root)
	end

	local paths = {}
	if link:sub(1, 1) == "/" then
		paths[1] = link
	else
		for _, base in ipairs(bases) do
			paths[#paths + 1] = vim.fs.joinpath(base, link)
		end
	end

	for _, path in ipairs(paths) do
		local file = vim.fs.normalize(path)
		for _, candidate in ipairs({ file, file .. ".md" }) do
			if vim.fn.filereadable(candidate) == 1 then
				vim.cmd("edit " .. vim.fn.fnameescape(candidate))
				return
			end
		end
	end

	if type(opts.find_files) == "function" then
		opts.find_files(link, vault_root or buffer_dir or vim.fn.getcwd())
	else
		vim.notify("File not found: " .. link, vim.log.levels.WARN)
	end
end

return M

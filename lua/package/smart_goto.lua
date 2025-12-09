local M = {}

local function normalize_md_link(word)
	word = word:gsub("^%(", ""):gsub("%)$", "")
	word = word:gsub("^%[", ""):gsub("%]$", "")
	word = word:gsub("^<", ""):gsub(">$", "")
	word = word:gsub("^.-%(", ""):gsub("%)$", "")
	word = word:gsub("#.*$", "")
	word = word:gsub("['\"]", ""):gsub("%s+", "")

	return word
end

function M.smart_goto()
	local params = vim.lsp.util.make_position_params(0, "utf-16")
	local results = vim.lsp.buf_request_sync(0, "textDocument/definition", params, 1000)

	local has_def = false
	if results then
		for _, res in pairs(results) do
			if res.result and next(res.result) then
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
	local path = normalize_md_link(word)
	if path == "" then
		vim.notify("Can't extract path from: " .. word, vim.log.levels.WARN)
		return
	end

	local file = vim.fn.fnamemodify(path, ":p")
	if vim.fn.filereadable(file) == 1 then
		vim.cmd("edit " .. file)
	else
		vim.notify("File not found: " .. file, vim.log.levels.WARN)
	end
end

return M

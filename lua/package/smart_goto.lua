local M = {}

-- Позволяет переходить по одному хоткею к файлам и definition'ам
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

	local file = vim.fn.expand("<cWORD>"):gsub("[\"'%s]", "")
	file = vim.fn.fnamemodify(file, ":p")

	if vim.fn.filereadable(file) == 1 then
		vim.cmd("edit " .. file)
	else
		vim.notify("File not found: " .. file, vim.log.levels.WARN)
	end
end

return M

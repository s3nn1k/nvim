local M = {}

function M.desc(desc)
	return "cfg: " .. desc
end

function M.opts(base_opts, desc, extra)
	return vim.tbl_extend("force", base_opts or {}, { desc = M.desc(desc) }, extra or {})
end

return M

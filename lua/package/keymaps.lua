local M = {}

M.PREFIX = "cfg: "
M.PATTERN = "^cfg:%s"

---@param desc string
---@return string
function M.desc(desc)
	return M.PREFIX .. desc
end

---@param base_opts table|nil
---@param desc string
---@param extra table|nil
---@return table
function M.opts(base_opts, desc, extra)
	return vim.tbl_extend("force", base_opts or {}, { desc = M.desc(desc) }, extra or {})
end

---@param desc string|nil
---@return boolean
function M.is_cfg(desc)
	return type(desc) == "string" and desc:find(M.PATTERN) ~= nil
end

---@param desc string|nil
---@return string
function M.strip(desc)
	if type(desc) ~= "string" then
		return ""
	end
	return (desc:gsub(M.PATTERN, ""))
end

return M

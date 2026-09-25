local M = {}

function M.frontmatter(note)
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
end

return M

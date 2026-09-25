local M = {}

local credentials_path = vim.fn.expand("~/.git-credentials")

M.remote_name = "origin"

local function notify_err(message)
	vim.notify("gitlab.nvim: " .. message, vim.log.levels.ERROR)
	return nil, nil, message
end

local function host_from_url(url)
	if url == nil then
		return nil
	end
	url = url:gsub("^%s+", ""):gsub("%s+$", "")
	local authority = url:match("^https?://([^/]+)") or url:match("@([^:/]+)")
	if authority == nil then
		return nil
	end
	return (authority:gsub("^[^@]*@", ""):gsub(":%d+$", ""))
end

local function remote_host()
	local url = vim.fn.system({ "git", "remote", "get-url", M.remote_name })
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return host_from_url(url)
end

local function project_file_auth()
	local root = vim.fn.system({ "git", "rev-parse", "--show-toplevel" })
	if vim.v.shell_error ~= 0 then
		return nil
	end
	root = root:gsub("%s+$", "")
	local file = io.open(root .. "/.gitlab.nvim", "r")
	if file == nil then
		return nil
	end
	local props = {}
	for line in file:lines() do
		local key, value = line:match("^%s*(.-)%s*=%s*(.-)%s*$")
		if key ~= nil and key ~= "" then
			props[key] = value
		end
	end
	file:close()
	if props.auth_token == nil or props.auth_token == "" then
		return nil
	end
	return props.auth_token, props.gitlab_url
end

local function vault_token(override_host)
	local host = override_host or remote_host() or "gitlab.com"
	local file = io.open(credentials_path, "r")
	if file == nil then
		return notify_err("vault credentials not found: " .. credentials_path)
	end
	local content = file:read("*a")
	file:close()
	for entry in content:gmatch("[^\r\n]+") do
		local line = entry:gsub("%s+$", "")
		local token, line_host = line:match("^https?://[^:@/]+:([^@]+)@(.+)$")
		if line_host == host then
			if host == "gitlab.com" then
				return token, nil, nil
			end
			return token, "https://" .. host, nil
		end
	end
	if not host:find("gitlab") then
		return notify_err("not a GitLab repository: " .. host)
	end
	return notify_err("no credentials for " .. host .. " in " .. credentials_path)
end

function M.auth_provider()
	local file_token, file_url = project_file_auth()
	if file_token ~= nil then
		return file_token, file_url or os.getenv("GITLAB_URL"), nil
	end
	local env_token = os.getenv("GITLAB_TOKEN")
	if env_token ~= nil and env_token ~= "" then
		return env_token, os.getenv("GITLAB_URL"), nil
	end
	return vault_token(host_from_url(os.getenv("GITLAB_URL")))
end

return M

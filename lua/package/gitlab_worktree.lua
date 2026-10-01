local M = {}

local active = nil

local notify_prefix = "gitlab worktree: "

local owner_file_name = ".gitlab-worktree-owner"

local function notify_error(message)
	vim.notify(notify_prefix .. message, vim.log.levels.ERROR)
end

local function run_git(args, cwd)
	local result = vim.system(vim.list_extend({ "git" }, args), { cwd = cwd, text = true }):wait()
	if result.code ~= 0 then
		local detail = vim.trim(result.stderr ~= "" and result.stderr or result.stdout or "")
		return nil, table.concat(args, " ") .. ": " .. detail
	end
	return result.stdout or "", nil
end

local function hash6(text)
	local hash = 5381
	for i = 1, #text do
		hash = (hash * 33 + string.byte(text, i)) % 4294967296
	end
	return string.format("%06x", hash % 16777216)
end

local function repo_identity()
	local raw, err = run_git({ "rev-parse", "--git-common-dir" })
	if err then
		return nil, err
	end
	local expanded = vim.fn.fnamemodify(vim.trim(raw or ""), ":p")
	local common_dir, realpath_err = vim.uv.fs_realpath(expanded)
	if not common_dir then
		return nil,
			"rev-parse --git-common-dir: cannot resolve " .. vim.trim(raw or "") .. ": " .. tostring(realpath_err)
	end
	local main_root = vim.fs.dirname(common_dir)
	local prefix = string.format("%s-%s-mr", vim.fn.fnamemodify(main_root, ":t"), hash6(common_dir))
	return { common_dir = common_dir, main_root = main_root, prefix = prefix }, nil
end

local function managed_path(identity, mr_iid)
	return vim.fs.normalize(vim.fn.stdpath("cache")) .. "/gitlab-review/" .. identity.prefix .. tostring(mr_iid)
end

local function remove_managed(identity, path)
	local _, remove_err = run_git({ "worktree", "remove", "--force", path }, identity.main_root)
	if remove_err then
		local ok, rm_err = pcall(vim.fs.rm, path, { recursive = true })
		if not ok then
			notify_error("cannot remove " .. path .. ": " .. tostring(rm_err))
			return
		end
	end
	run_git({ "worktree", "prune" }, identity.main_root)
end

local function write_owner_marker(path)
	local file = io.open(path .. "/" .. owner_file_name, "w")
	if not file then
		notify_error("cannot write owner marker in " .. path)
		return false
	end
	file:write(tostring(vim.uv.getpid()))
	file:close()
	return true
end

local function read_owner_pid(path)
	local file = io.open(path .. "/" .. owner_file_name, "r")
	if not file then
		return nil
	end
	local pid = tonumber(file:read("*l"))
	file:close()
	return pid
end

local function owner_alive(path)
	local pid = read_owner_pid(path)
	if not pid then
		return false
	end
	local signal, err = vim.uv.kill(pid, 0)
	if signal then
		return true
	end
	err = tostring(err)
	if err:find("EPERM") then
		return true
	end
	return false
end

local function current_branch(root)
	local output, err = run_git({ "branch", "--show-current" }, root)
	if err then
		return nil, err
	end
	return vim.trim(output or ""), nil
end

local function branch_exists(root, branch)
	local result = vim.system({ "git", "show-ref", "--verify", "--quiet", "refs/heads/" .. branch }, { cwd = root })
		:wait()
	return result.code == 0
end

local function worktree_add(identity, path, mr)
	local branch = mr.source_branch
	local args
	if branch_exists(identity.main_root, branch) then
		args = { "worktree", "add", path, branch }
	else
		args = { "worktree", "add", "-b", branch, path, "origin/" .. branch }
	end
	local _, err = run_git(args, identity.main_root)
	return err
end

function M.open(mr, opts)
	opts = opts or {}

	if active then
		notify_error("close current review first (glQ)")
		return
	end

	local identity, err = repo_identity()
	if not identity then
		notify_error(err)
		return
	end

	local branch, branch_err = current_branch(identity.main_root)
	if branch_err then
		notify_error(branch_err)
		return
	end
	if branch == mr.source_branch then
		vim.notify(notify_prefix .. "already on MR branch, use glS", vim.log.levels.WARN)
		return
	end

	local _, fetch_err = run_git({ "fetch", "origin", mr.source_branch }, identity.main_root)
	if fetch_err then
		notify_error(fetch_err)
		return
	end

	local path = managed_path(identity, mr.iid)
	if vim.fn.isdirectory(path) == 1 then
		local owner_pid = read_owner_pid(path)
		if owner_pid and owner_alive(path) and owner_pid ~= vim.uv.getpid() then
			notify_error("review worktree in use by pid " .. owner_pid)
			return
		end
		remove_managed(identity, path)
	end

	if opts.close_review then
		opts.close_review()
	end

	local add_err = worktree_add(identity, path, mr)
	if add_err then
		notify_error(add_err)
		return
	end
	if not write_owner_marker(path) then
		remove_managed(identity, path)
		return
	end

	local prev_dir = vim.fn.getcwd() or path
	vim.api.nvim_set_current_dir(path)
	opts.start_review(mr)
	active = { path = path, prev_dir = prev_dir, main_root = identity.main_root }
end

function M.close()
	if not active then
		return
	end
	local owner_pid = read_owner_pid(active.path)
	if owner_pid and owner_alive(active.path) and owner_pid ~= vim.uv.getpid() then
		notify_error("review worktree in use by pid " .. owner_pid)
		if not pcall(vim.api.nvim_set_current_dir, active.prev_dir) then
			pcall(vim.api.nvim_set_current_dir, active.main_root)
		end
		active = nil
		return
	end
	local cd_ok = pcall(vim.api.nvim_set_current_dir, active.prev_dir)
	if not cd_ok then
		pcall(vim.api.nvim_set_current_dir, active.main_root)
	end
	remove_managed({ main_root = active.main_root }, active.path)
	active = nil
end

function M.sweep()
	local identity, err = repo_identity()
	if not identity then
		return
	end
	local pattern = "^" .. vim.pesc(identity.prefix) .. "%d+$"
	local managed_root = vim.fs.normalize(vim.fn.stdpath("cache")) .. "/gitlab-review"
	for entry in vim.fs.dir(managed_root) do
		if entry:match(pattern) and vim.fn.isdirectory(managed_root .. "/" .. entry) == 1 then
			local path = managed_root .. "/" .. entry
			if not owner_alive(path) then
				remove_managed(identity, path)
			end
		end
	end
	run_git({ "worktree", "prune" }, identity.main_root)
end

return M

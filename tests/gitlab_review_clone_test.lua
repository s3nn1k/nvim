local here = vim.fs.normalize(debug.getinfo(1, "S").source:sub(2))
local repo_root = vim.fs.dirname(vim.fs.dirname(here))
local module_path = repo_root .. "/lua/package/gitlab_review_clone.lua"

local passed = 0
local failed = 0

local function check(label, ok, detail)
	if ok then
		passed = passed + 1
		print("PASS " .. label)
		return
	end
	failed = failed + 1
	print("FAIL " .. label .. (detail and (": " .. detail) or ""))
end

local function eq(label, got, want)
	if vim.deep_equal(got, want) then
		check(label, true)
		return
	end
	check(label, false, "got " .. vim.inspect(got) .. ", want " .. vim.inspect(want))
end

local function git_key(argv)
	if argv[1] ~= "git" then
		return nil
	end
	if argv[2] == "rev-parse" and argv[3] == "--git-common-dir" then
		return "common_dir"
	end
	if argv[2] == "rev-parse" then
		return "verify"
	end
	return argv[2]
end

local function calls_of(record, key)
	local found = {}
	for _, call in ipairs(record.git) do
		if git_key(call.argv) == key then
			table.insert(found, call)
		end
	end
	return found
end

local function notify_of(record, level)
	for _, note in ipairs(record.notifications) do
		if note.level == level then
			return note
		end
	end
	return nil
end

local function harness(responses)
	local tmp = assert(vim.uv.fs_mkdtemp("/tmp/nvim_grc_test_XXXXXX"), "cannot create temp dir")
	local record = {
		tmp = tmp,
		main_root = tmp .. "/gitroot",
		git = {},
		notifications = {},
		dirs = { current = nil },
		review_starts = {},
		fs_unlinks = {},
		removed = {},
		dirs_exist = {},
		dir_entries = {},
		cwd = nil,
	}
	local original = {
		system = vim.system,
		notify = vim.notify,
		getcwd = vim.fn.getcwd,
		isdirectory = vim.fn.isdirectory,
		stdpath = vim.fn.stdpath,
		fs_realpath = vim.uv.fs_realpath,
		kill = vim.uv.kill,
		fs_unlink = vim.uv.fs_unlink,
		set_current_dir = vim.api.nvim_set_current_dir,
		fs_rm = vim.fs.rm,
		dir = vim.fs.dir,
	}
	vim.system = function(argv, opts)
		table.insert(record.git, { argv = argv, cwd = opts and opts.cwd or nil })
		local key = git_key(argv)
		local response = (key and responses[key]) or { code = 0, stdout = "" }
		return {
			wait = function()
				return response
			end,
		}
	end
	vim.notify = function(message, level)
		table.insert(record.notifications, { message = message, level = level })
	end
	vim.fn.getcwd = function()
		return record.cwd or "/prev/dir"
	end
	vim.fn.isdirectory = function(path)
		return record.dirs_exist[path] and 1 or 0
	end
	vim.fn.stdpath = function(what)
		if what == "cache" then
			return tmp .. "/cache"
		end
		return original.stdpath(what)
	end
	vim.uv.fs_realpath = function(path)
		return path, nil
	end
	vim.uv.kill = function()
		return true
	end
	vim.uv.fs_unlink = function(path)
		table.insert(record.fs_unlinks, path)
		return true
	end
	vim.api.nvim_set_current_dir = function(path)
		record.dirs.current = path
		return true
	end
	vim.fs.rm = function(path, opts)
		table.insert(record.removed, { path = path, opts = opts })
		record.dirs_exist[path] = nil
	end
	vim.fs.dir = function(dir)
		local names = record.dir_entries[dir] or {}
		local index = 0
		return function()
			index = index + 1
			return names[index]
		end
	end
	record.restore = function()
		vim.system = original.system
		vim.notify = original.notify
		vim.fn.getcwd = original.getcwd
		vim.fn.isdirectory = original.isdirectory
		vim.fn.stdpath = original.stdpath
		vim.uv.fs_realpath = original.fs_realpath
		vim.uv.kill = original.kill
		vim.uv.fs_unlink = original.fs_unlink
		vim.api.nvim_set_current_dir = original.set_current_dir
		vim.fs.rm = original.fs_rm
		vim.fs.dir = original.dir
	end
	return record
end

local function teardown(record)
	record.restore()
	vim.fs.rm(record.tmp, { recursive = true })
end

local function fresh_module()
	return dofile(module_path)
end

local function make_mr()
	return { iid = 42, source_branch = "feature-x", target_branch = "main", title = "T", author = { name = "a" } }
end

local function hash6(text)
	local hash = 5381
	for i = 1, #text do
		hash = (hash * 33 + string.byte(text, i)) % 4294967296
	end
	return string.format("%06x", hash % 16777216)
end

local function open_mr(record, mr)
	local review_clone = fresh_module()
	review_clone.open(mr, {
		start_review = function(chosen)
			table.insert(record.review_starts, chosen)
		end,
	})
	return review_clone
end

local function assert_failure_cleanup(record, label, path)
	eq(
		label .. " removes managed dir recursively once",
		record.removed,
		{ { path = path, opts = { recursive = true } } }
	)
	eq(label .. " unlinks owner file", record.fs_unlinks, { path .. ".owner" })
	eq(label .. " does not start review", record.review_starts, {})
	eq(label .. " does not switch current dir", record.dirs.current, nil)
end

local function scenario_open_clones_repo_and_checks_out_mr_branch()
	local responses = {
		branch = { code = 0, stdout = "main\n" },
		remote = { code = 0, stdout = "git@example.com:group/repo.git\n" },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local mr = make_mr()
	local review_clone = open_mr(record, mr)

	local remotes = calls_of(record, "remote")
	eq("remote url read once", #remotes, 1)
	if remotes[1] then
		eq("remote url argv", remotes[1].argv, { "git", "remote", "get-url", "origin" })
		eq("remote url read in main repo root", remotes[1].cwd, record.main_root)
	end

	local clones = calls_of(record, "clone")
	eq("clone called once", #clones, 1)
	local path = clones[1] and clones[1].argv[5] or nil
	if clones[1] then
		eq(
			"clone argv is full clone into managed path",
			clones[1].argv,
			{ "git", "clone", "--quiet", "git@example.com:group/repo.git", path }
		)
		eq("clone runs in main repo root", clones[1].cwd, record.main_root)
	end

	local fetches = calls_of(record, "fetch")
	eq("mr head fetched once", #fetches, 1)
	if fetches[1] then
		eq(
			"fetch argv targets mr head ref without local dest",
			fetches[1].argv,
			{ "git", "fetch", "--quiet", "origin", "refs/merge-requests/42/head" }
		)
		eq("fetch runs in review clone", fetches[1].cwd, path)
	end

	local update_refs = calls_of(record, "update-ref")
	eq("mr head ref synthesized once", #update_refs, 1)
	if update_refs[1] then
		eq(
			"update-ref argv synthesizes remote-tracking ref from fetch head",
			update_refs[1].argv,
			{ "git", "update-ref", "refs/remotes/origin/feature-x", "FETCH_HEAD" }
		)
		eq("update-ref runs in review clone", update_refs[1].cwd, path)
	end

	local checkouts = calls_of(record, "checkout")
	eq("mr branch checked out once", #checkouts, 1)
	if checkouts[1] then
		eq(
			"checkout argv resets source branch to remote-tracking ref",
			checkouts[1].argv,
			{ "git", "checkout", "--quiet", "-B", "feature-x", "origin/feature-x" }
		)
		eq("checkout runs in review clone", checkouts[1].cwd, path)
	end

	local verifies = calls_of(record, "verify")
	eq("clone verified once", #verifies, 1)
	if verifies[1] then
		eq("verify runs in review clone", verifies[1].cwd, path)
	end

	for _, call in ipairs(record.git) do
		check(
			"no git worktree commands in " .. table.concat(call.argv, " "),
			call.argv[1] ~= "git" or call.argv[2] ~= "worktree"
		)
	end

	eq("current dir switched to review clone path", record.dirs.current, path)
	eq("review started with the chosen mr", record.review_starts, { mr })

	review_clone.close()
	eq("close removes review clone recursively once", record.removed, { { path = path, opts = { recursive = true } } })
	eq("close unlinks owner file", record.fs_unlinks, { path .. ".owner" })
	eq("current dir restored after close", record.dirs.current, "/prev/dir")
	teardown(record)
end

local function scenario_open_refuses_when_already_on_mr_branch()
	local responses = {
		branch = { code = 0, stdout = "feature-x\n" },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local mr = make_mr()
	open_mr(record, mr)

	local warn = notify_of(record, vim.log.levels.WARN)
	check(
		"warns about already being on mr branch",
		warn ~= nil and warn.message:find("already on MR branch, use glS", 1, true) ~= nil,
		vim.inspect(record.notifications)
	)
	eq("no remote url read when already on mr branch", #calls_of(record, "remote"), 0)
	eq("no clone when already on mr branch", #calls_of(record, "clone"), 0)
	eq("no fetch when already on mr branch", #calls_of(record, "fetch"), 0)
	eq("no checkout when already on mr branch", #calls_of(record, "checkout"), 0)
	eq("no cleanup when already on mr branch", record.removed, {})
	eq("review not started when already on mr branch", record.review_starts, {})
	eq("current dir unchanged when already on mr branch", record.dirs.current, nil)
	teardown(record)
end

local function scenario_clone_failure_cleans_up()
	local responses = {
		branch = { code = 0, stdout = "main\n" },
		remote = { code = 0, stdout = "git@example.com:group/repo.git\n" },
		clone = { code = 128, stderr = "fatal: destination path already exists\n" },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local mr = make_mr()
	open_mr(record, mr)

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check(
		"reports clone failure",
		error_note ~= nil
			and error_note.message:find("clone --quiet", 1, true) ~= nil
			and error_note.message:find("destination path already exists", 1, true) ~= nil,
		vim.inspect(record.notifications)
	)
	local path = calls_of(record, "clone")[1] and calls_of(record, "clone")[1].argv[5] or nil
	assert_failure_cleanup(record, "clone failure", path)
	teardown(record)
end

local function scenario_mr_head_fetch_failure_cleans_up()
	local responses = {
		branch = { code = 0, stdout = "main\n" },
		remote = { code = 0, stdout = "git@example.com:group/repo.git\n" },
		fetch = { code = 128, stderr = "fatal: could not read from remote repository\n" },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local mr = make_mr()
	open_mr(record, mr)

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check(
		"reports mr head fetch failure",
		error_note ~= nil
			and error_note.message:find("fetch --quiet origin refs/merge-requests/42/head", 1, true) ~= nil
			and error_note.message:find("could not read from remote repository", 1, true) ~= nil,
		vim.inspect(record.notifications)
	)
	local path = calls_of(record, "clone")[1] and calls_of(record, "clone")[1].argv[5] or nil
	assert_failure_cleanup(record, "fetch failure", path)
	teardown(record)
end

local function scenario_mr_head_update_ref_failure_cleans_up()
	local responses = {
		branch = { code = 0, stdout = "main\n" },
		remote = { code = 0, stdout = "git@example.com:group/repo.git\n" },
		["update-ref"] = { code = 128, stderr = "fatal: cannot lock ref 'refs/remotes/origin/feature-x'\n" },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local mr = make_mr()
	open_mr(record, mr)

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check(
		"reports update-ref failure",
		error_note ~= nil
			and error_note.message:find("update-ref refs/remotes/origin/feature-x FETCH_HEAD", 1, true) ~= nil
			and error_note.message:find("cannot lock ref", 1, true) ~= nil,
		vim.inspect(record.notifications)
	)
	local path = calls_of(record, "clone")[1] and calls_of(record, "clone")[1].argv[5] or nil
	assert_failure_cleanup(record, "update-ref failure", path)
	teardown(record)
end

local function scenario_mr_branch_checkout_failure_cleans_up()
	local responses = {
		branch = { code = 0, stdout = "main\n" },
		remote = { code = 0, stdout = "git@example.com:group/repo.git\n" },
		checkout = { code = 1, stderr = "error: pathspec 'feature-x' did not match any file(s) known to git\n" },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local mr = make_mr()
	open_mr(record, mr)

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check(
		"reports checkout failure",
		error_note ~= nil
			and error_note.message:find("checkout --quiet -B feature-x origin/feature-x", 1, true) ~= nil
			and error_note.message:find("pathspec", 1, true) ~= nil,
		vim.inspect(record.notifications)
	)
	local path = calls_of(record, "clone")[1] and calls_of(record, "clone")[1].argv[5] or nil
	assert_failure_cleanup(record, "checkout failure", path)
	teardown(record)
end

local function scenario_broken_clone_is_removed()
	local responses = {
		branch = { code = 0, stdout = "main\n" },
		remote = { code = 0, stdout = "git@example.com:group/repo.git\n" },
		verify = { code = 1, stderr = "" },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local mr = make_mr()
	open_mr(record, mr)

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check(
		"reports broken created review clone",
		error_note ~= nil and error_note.message:find("created review clone is broken", 1, true) ~= nil,
		vim.inspect(record.notifications)
	)
	local path = calls_of(record, "clone")[1] and calls_of(record, "clone")[1].argv[5] or nil
	assert_failure_cleanup(record, "broken clone", path)
	teardown(record)
end

local function scenario_sweep_removes_stale_clones_only()
	local responses = {}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. "/.git\n" }
	local prefix = "gitroot-" .. hash6(record.main_root .. "/.git") .. "-mr"
	local managed_root = record.tmp .. "/cache/gitlab-review"
	local stale = managed_root .. "/" .. prefix .. "17"
	local live = managed_root .. "/" .. prefix .. "18"
	local current = managed_root .. "/" .. prefix .. "19"
	record.dirs_exist = { [stale] = true, [live] = true, [current] = true }
	record.dir_entries = {
		[managed_root] = { prefix .. "17", prefix .. "18", prefix .. "19", prefix .. "42.owner", "unrelated" },
	}
	record.cwd = current
	vim.fn.mkdir(managed_root, "p")
	local owner = io.open(live .. ".owner", "w")
	assert(owner, "cannot write live owner file")
	owner:write(tostring(vim.uv.getpid()) .. "\n\n")
	owner:close()

	fresh_module().sweep()

	eq("sweep removes stale clone only", record.removed, { { path = stale, opts = { recursive = true } } })
	eq(
		"sweep unlinks stale and orphan owner files",
		record.fs_unlinks,
		{ stale .. ".owner", managed_root .. "/" .. prefix .. "42.owner" }
	)
	teardown(record)
end

local scenarios = {
	scenario_sweep_removes_stale_clones_only,
	scenario_open_clones_repo_and_checks_out_mr_branch,
	scenario_open_refuses_when_already_on_mr_branch,
	scenario_clone_failure_cleans_up,
	scenario_mr_head_fetch_failure_cleans_up,
	scenario_mr_head_update_ref_failure_cleans_up,
	scenario_mr_branch_checkout_failure_cleans_up,
	scenario_broken_clone_is_removed,
}

for _, scenario in ipairs(scenarios) do
	local ok, err = pcall(scenario)
	if not ok then
		failed = failed + 1
		print("FAIL scenario crashed: " .. tostring(err))
	end
end

print(string.format("%d checks passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)

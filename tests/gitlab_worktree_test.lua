local here = vim.fs.normalize(debug.getinfo(1, 'S').source:sub(2))
local repo_root = vim.fs.dirname(vim.fs.dirname(here))
local module_path = repo_root .. '/lua/package/gitlab_worktree.lua'

local passed = 0
local failed = 0

local function check(label, ok, detail)
	if ok then
		passed = passed + 1
		print('PASS ' .. label)
		return
	end
	failed = failed + 1
	print('FAIL ' .. label .. (detail and (': ' .. detail) or ''))
end

local function eq(label, got, want)
	if vim.deep_equal(got, want) then
		check(label, true)
		return
	end
	check(label, false, 'got ' .. vim.inspect(got) .. ', want ' .. vim.inspect(want))
end

local function git_key(argv)
	if argv[1] ~= 'git' then
		return nil
	end
	if argv[2] == 'worktree' then
		return 'worktree_' .. argv[3]
	end
	if argv[2] == 'rev-parse' and argv[3] == '--git-common-dir' then
		return 'common_dir'
	end
	if argv[2] == 'rev-parse' then
		return 'verify'
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
	local tmp = assert(vim.uv.fs_mkdtemp('/tmp/nvim_gwt_test_XXXXXX'), 'cannot create temp dir')
	local record = {
		tmp = tmp,
		main_root = tmp .. '/gitroot',
		git = {},
		notifications = {},
		dirs = { current = nil },
		review_starts = {},
		fs_unlinks = {},
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
	}
	vim.system = function(argv, opts)
		table.insert(record.git, { argv = argv, cwd = opts and opts.cwd or nil })
		local key = git_key(argv)
		local response = (key and responses[key]) or { code = 0, stdout = '' }
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
		return '/prev/dir'
	end
	vim.fn.isdirectory = function()
		return 0
	end
	vim.fn.stdpath = function(what)
		if what == 'cache' then
			return tmp .. '/cache'
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
	vim.fs.rm = function(path)
		error('unexpected vim.fs.rm on ' .. tostring(path))
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
	return { iid = 42, source_branch = 'feature-x', target_branch = 'main', title = 'T', author = { name = 'a' } }
end

local function scenario_open_fetches_mr_head_and_adds_detached_worktree()
	local responses = {
		branch = { code = 0, stdout = 'main\n' },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. '/.git\n' }
	local mr = make_mr()
	local worktree = fresh_module()
	worktree.open(mr, {
		start_review = function(chosen)
			table.insert(record.review_starts, chosen)
		end,
	})

	local fetches = calls_of(record, 'fetch')
	eq('fetch called once', #fetches, 1)
	if fetches[1] then
		eq('fetch argv targets mr head ref without local dest', fetches[1].argv, { 'git', 'fetch', 'origin', 'refs/merge-requests/42/head' })
		eq('fetch runs in main repo root', fetches[1].cwd, record.main_root)
	end

	local adds = calls_of(record, 'worktree_add')
	eq('worktree add called once', #adds, 1)
	if adds[1] then
		local path = adds[1].argv[5]
		eq('worktree add argv is detached from FETCH_HEAD', adds[1].argv, { 'git', 'worktree', 'add', '--detach', path, 'FETCH_HEAD' })
		eq('worktree add runs in main repo root', adds[1].cwd, record.main_root)
	end

	for _, call in ipairs(record.git) do
		local creates_branch = call.argv[2] == 'checkout'
			or call.argv[2] == 'switch'
			or (call.argv[2] == 'branch' and call.argv[3] ~= '--show-current')
			or (call.argv[2] == 'worktree' and call.argv[3] == 'add' and (call.argv[4] ~= '--detach' or call.argv[5] == '-b' or call.argv[5] == '-B'))
		check('no local branch creation in ' .. table.concat(call.argv, ' '), not creates_branch)
	end
	eq('no managed worktree removed while review is open', #calls_of(record, 'worktree_remove'), 0)
	eq('current dir switched to worktree path', record.dirs.current, adds[1] and adds[1].argv[5] or nil)
	eq('review started with the chosen mr', record.review_starts, { mr })

	worktree.close()
	local removes = calls_of(record, 'worktree_remove')
	eq('close removes managed worktree once', #removes, 1)
	if removes[1] then
		eq('close remove argv', removes[1].argv, { 'git', 'worktree', 'remove', '--force', adds[1].argv[5] })
		eq('close remove runs in main repo root', removes[1].cwd, record.main_root)
	end
	local prunes = calls_of(record, 'worktree_prune')
	eq('close prunes worktrees once', #prunes, 1)
	if prunes[1] then
		eq('close prune argv', prunes[1].argv, { 'git', 'worktree', 'prune' })
		eq('close prune runs in main repo root', prunes[1].cwd, record.main_root)
	end
	eq('current dir restored after close', record.dirs.current, '/prev/dir')
	teardown(record)
end

local function scenario_open_refuses_when_already_on_mr_branch()
	local responses = {
		branch = { code = 0, stdout = 'feature-x\n' },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. '/.git\n' }
	local mr = make_mr()
	local worktree = fresh_module()
	worktree.open(mr, {
		start_review = function(chosen)
			table.insert(record.review_starts, chosen)
		end,
	})

	local warn = notify_of(record, vim.log.levels.WARN)
	check('warns about already being on mr branch', warn ~= nil and warn.message:find('already on MR branch, use glS', 1, true) ~= nil, vim.inspect(record.notifications))
	eq('no fetch when already on mr branch', #calls_of(record, 'fetch'), 0)
	eq('no worktree add when already on mr branch', #calls_of(record, 'worktree_add'), 0)
	eq('review not started when already on mr branch', record.review_starts, {})
	eq('current dir unchanged when already on mr branch', record.dirs.current, nil)
	teardown(record)
end

local function scenario_fetch_failure_aborts_without_worktree()
	local responses = {
		branch = { code = 0, stdout = 'main\n' },
		fetch = { code = 128, stderr = 'fatal: could not read from remote repository\n' },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. '/.git\n' }
	local mr = make_mr()
	local worktree = fresh_module()
	worktree.open(mr, {
		start_review = function(chosen)
			table.insert(record.review_starts, chosen)
		end,
	})

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check('reports fetch failure', error_note ~= nil and error_note.message:find('fetch origin refs/merge-requests/42/head', 1, true) ~= nil and error_note.message:find('could not read from remote repository', 1, true) ~= nil, vim.inspect(record.notifications))
	eq('no worktree add after fetch failure', #calls_of(record, 'worktree_add'), 0)
	eq('no cleanup after fetch failure', #calls_of(record, 'worktree_remove') + #calls_of(record, 'worktree_prune'), 0)
	eq('review not started after fetch failure', record.review_starts, {})
	eq('current dir unchanged after fetch failure', record.dirs.current, nil)
	teardown(record)
end

local function scenario_worktree_add_failure_cleans_up()
	local responses = {
		branch = { code = 0, stdout = 'main\n' },
		worktree_add = { code = 1, stderr = 'fatal: unable to create worktree\n' },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. '/.git\n' }
	local mr = make_mr()
	local worktree = fresh_module()
	worktree.open(mr, {
		start_review = function(chosen)
			table.insert(record.review_starts, chosen)
		end,
	})

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check('reports worktree add failure', error_note ~= nil and error_note.message:find('worktree add --detach', 1, true) ~= nil and error_note.message:find('fatal: unable to create worktree', 1, true) ~= nil, vim.inspect(record.notifications))
	local removes = calls_of(record, 'worktree_remove')
	eq('failed worktree add cleans up managed path', #removes, 1)
	if removes[1] then
		local path = removes[1].argv[5]
		eq('cleanup remove argv', removes[1].argv, { 'git', 'worktree', 'remove', '--force', path })
		eq('cleanup remove runs in main repo root', removes[1].cwd, record.main_root)
		eq('cleanup unlinks owner file', record.fs_unlinks, { path .. '.owner' })
	end
	eq('cleanup prunes worktrees', #calls_of(record, 'worktree_prune'), 1)
	eq('review not started after worktree add failure', record.review_starts, {})
	eq('current dir unchanged after worktree add failure', record.dirs.current, nil)
	teardown(record)
end

local function scenario_broken_worktree_is_removed()
	local responses = {
		branch = { code = 0, stdout = 'main\n' },
		verify = { code = 1, stderr = '' },
	}
	local record = harness(responses)
	responses.common_dir = { code = 0, stdout = record.main_root .. '/.git\n' }
	local mr = make_mr()
	local worktree = fresh_module()
	worktree.open(mr, {
		start_review = function(chosen)
			table.insert(record.review_starts, chosen)
		end,
	})

	local error_note = notify_of(record, vim.log.levels.ERROR)
	check('reports broken created worktree', error_note ~= nil and error_note.message:find('created worktree is broken', 1, true) ~= nil, vim.inspect(record.notifications))
	eq('broken worktree is cleaned up', #calls_of(record, 'worktree_remove'), 1)
	eq('broken worktree cleanup prunes', #calls_of(record, 'worktree_prune'), 1)
	eq('review not started for broken worktree', record.review_starts, {})
	eq('current dir unchanged for broken worktree', record.dirs.current, nil)
	teardown(record)
end

local scenarios = {
	scenario_open_fetches_mr_head_and_adds_detached_worktree,
	scenario_open_refuses_when_already_on_mr_branch,
	scenario_fetch_failure_aborts_without_worktree,
	scenario_worktree_add_failure_cleans_up,
	scenario_broken_worktree_is_removed,
}

for _, scenario in ipairs(scenarios) do
	local ok, err = pcall(scenario)
	if not ok then
		failed = failed + 1
		print('FAIL scenario crashed: ' .. tostring(err))
	end
end

print(string.format('%d checks passed, %d failed', passed, failed))
os.exit(failed == 0 and 0 or 1)

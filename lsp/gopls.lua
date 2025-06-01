return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
	root_markers = { "go.mod", "go.sum", "go.work", ".git" },
	settings = {
		gopls = {
			buildFlags = { "-tags=tests,integration" }, -- (for magnit and wb tests) TODO: Fix it
		},
		staticcheck = true,
	},
}

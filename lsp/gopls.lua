return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl", "gosum" },
	root_markers = { "go.mod", "go.sum", "go.work", ".git" },
	settings = {
		gopls = {
			completeUnimported = true,
			analyses = {
				unusedvariable = true,
				shadow = true,
			},
		},
		staticcheck = true,
	},
}

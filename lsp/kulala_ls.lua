return {
	cmd = { "kulala-ls", "--stdio" },
	filetypes = { "http", "rest" },
	root_markers = { ".git" },
	single_file_support = true,
	settings = {
		kulala = {
			lint_on_save = true,
			validate_headers = true,
		},
	},
}

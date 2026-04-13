-- Enabled LSP Servers
vim.lsp.enable({
	"gopls",
	"lua_ls",
	"kulala_ls",
	"pyright_ls",
})

-- Visual
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	virtual_text = false,
	float = { border = "single" },
})

-- Lsp Autocmd
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-config", {}),
	callback = function(ev)
		local km = require("package.keymaps")
		local base_opts = { buffer = ev.buf, silent = true }
		local function opts(desc, extra)
			return km.opts(base_opts, desc, extra)
		end
		local buf = vim.lsp.buf
		local map = vim.keymap
		local builtin = require("telescope.builtin")

		map.set("n", "<leader>k", function()
			buf.hover({ border = "single" })
		end, opts("LSP hover"))

		map.set("n", "<leader>h", vim.diagnostic.open_float, opts("Line diagnostics"))
		map.set("n", "<leader>R", buf.rename, opts("Rename symbol"))
		map.set("n", "<leader>r", builtin.lsp_references, opts("References"))
		map.set("n", "<leader>i", builtin.lsp_implementations, opts("Implementations"))
		map.set("n", "<leader>la", buf.code_action, opts("Code action"))
		map.set("n", "<leader>ld", buf.type_definition, opts("Type definition"))
	end,
})

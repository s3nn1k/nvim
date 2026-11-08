vim.lsp.enable({ "gopls", "lua_ls", "pyright_ls", "ts_ls", "kulala_ls" })

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "󰌵",
		},
	},
	virtual_text = false,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		local km = require("core.keys")
		local function opts(desc)
			return km.opts({ buffer = ev.buf, silent = true }, desc)
		end
		local map = vim.keymap.set

		map("n", "<leader>k", vim.lsp.buf.hover, opts("LSP hover"))
		map("n", "<leader>h", vim.diagnostic.open_float, opts("Line diagnostics"))
		map("n", "<leader>la", vim.lsp.buf.code_action, opts("Code action"))
	end,
})

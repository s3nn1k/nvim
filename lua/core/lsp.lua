vim.lsp.enable({ "gopls", "luals", "pyright", "tsc", "bashls" })

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
})

vim.keymap.set("n", "<leader>d", vim.diagnostic.setqflist, {
	silent = true,
	desc = "Diagnostics to quickfix",
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		local function lsp_picker(picker)
			return function()
				require("telescope.builtin")[picker]({ reuse_win = true })
			end
		end
		local function opts(desc)
			return { buffer = ev.buf, silent = true, desc = desc }
		end
		local map = vim.keymap.set

		map("n", "<leader>h", vim.diagnostic.open_float, opts("Line diagnostics"))
		map("n", "gd", lsp_picker("lsp_definitions"), opts("LSP definitions"))
		map("n", "grr", lsp_picker("lsp_references"), opts("LSP references"))
		map("n", "gri", lsp_picker("lsp_implementations"), opts("LSP implementations"))
	end,
})

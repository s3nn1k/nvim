return {
	"neovim/nvim-lspconfig",
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
		-- Cmp capability
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Lsp configuration
		local lsp = require("lspconfig")
		lsp.gopls.setup({
			capabilities = capabilities,
			settings = {
				gopls = {
					buildFlags = { "-tags=tests" }, -- (for magnit tests) TODO: Fix it
				},
			},
		})

		-- Enable it if you need
		-- lsp.pyright.setup({ capabilities = capabilities })
		-- lsp.ts_ls.setup({ capabilities = capabilities })
		lsp.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},
					diagnostics = {
						globals = {
							"vim",
							"require",
						},
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
						},
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

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
				local opts = { buffer = ev.buf }
				local buf = vim.lsp.buf
				local map = vim.keymap
				local builtin = require("telescope.builtin")

				map.set("n", "<leader>k", function()
					buf.hover({ border = "single" })
				end, opts)

				map.set("n", "<leader>h", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
				map.set("n", "<leader>R", buf.rename, opts)
				map.set("n", "<leader>d", builtin.lsp_definitions, opts)
				map.set("n", "<leader>r", builtin.lsp_references, opts)
				map.set("n", "<leader>i", builtin.lsp_implementations, opts)
				map.set("n", "<leader>e", builtin.lsp_document_symbols, opts)
			end,
		})
	end,
}

return {
	"neovim/nvim-lspconfig",
	dependencies = { "hrsh7th/cmp-nvim-lsp" },
	config = function()
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
				local opts = { buffer = ev.buf }
				local buf = vim.lsp.buf
				local map = vim.keymap
				local builtin = require("telescope.builtin")

				map.set("n", "<leader>k", function()
					buf.hover({ border = "single" })
				end, opts)

				map.set("n", "<leader>h", vim.diagnostic.open_float, opts)
				map.set("n", "<leader>R", buf.rename, opts)
				map.set("n", "<leader>d", builtin.lsp_definitions, opts)
				map.set("n", "<leader>r", builtin.lsp_references, opts)
				map.set("n", "<leader>i", builtin.lsp_implementations, opts)
			end,
		})

		-- Cmp capability
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Lsp configuration
		local lsp = require("lspconfig")
		lsp.gopls.setup({
			capabilities = capabilities,
			settings = {
				gopls = {
					buildFlags = { "-tags=tests,integration" }, -- (for magnit and wb tests) TODO: Fix it
				},
				staticcheck = true,
			},
		})

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
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		-- Enable it if you need
		-- lsp.pyright.setup({ capabilities = capabilities })
		-- lsp.ts_ls.setup({ capabilities = capabilities })
	end,
}

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier_md" },
				yaml = { "prettier" },
				toml = { "taplo" },
				sql = { "sql_formatter" },
				python = { "black" },
			},

			formatters = {
				prettier_md = {
					command = "prettier",
					args = {
						"--stdin-filepath",
						"$FILENAME",
						"--prose-wrap",
						"always",
						"--print-width",
						"90",
						"--embedded-language-formatting",
						"off",
					},
				},
				sql_formatter = {
					args = { "--language", "postgresql" },
				},
			},

			format_on_save = function(bufnr)
				if vim.b[bufnr].disable_autoformat then
					return nil
				end
				return {
					lsp_format = "never",
					timeout_ms = 3000,
				}
			end,
		})

		vim.keymap.set("n", "<leader>a", function()
			vim.b.disable_autoformat = not vim.b.disable_autoformat
			print("Autoformat: " .. (vim.b.disable_autoformat and "OFF" or "ON"))
		end, { noremap = true, silent = true, desc = "Toggle autoformat" })
	end,
}

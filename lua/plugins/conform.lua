return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports" },
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
				yml = { "prettier" },
				toml = { "taplo" },
				sql = { "sql_formatter" },
				-- python = { "black" },
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- javascriptreact = { "prettier" },
				-- typescriptreact = { "prettier" },
				-- css = { "prettier" },
				-- html = { "prettier" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 1250,
			},
		})
	end,
}

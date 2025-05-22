return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports" },

				-- Enable it if you need
				-- python = { "black" },
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- javascriptreact = { "prettier" },
				-- typescriptreact = { "prettier" },
				-- css = { "prettier" },
				-- html = { "prettier" },
				-- yaml = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier" },
				sql = { "sql_formatter" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 1250,
			},
		})
	end,
}

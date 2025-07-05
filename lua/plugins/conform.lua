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

				-- Enable it if you need
				-- python = { "black" },
				-- sql = { "sql_formatter" },
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- javascriptreact = { "prettier" },
				-- typescriptreact = { "prettier" },
				-- css = { "prettier" },
				-- html = { "prettier" },
				-- yaml = { "prettier" },
			},
			format_on_save = {
				lsp_format = "fallback",
				timeout_ms = 1250,
			},
		})
	end,
}

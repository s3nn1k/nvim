return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "injected" }, -- injected для sql форматтирования внутри go кода
				json = { "prettier" },
				markdown = { "prettier" },
				yaml = { "prettier" },
				yml = { "prettier" },
				toml = { "taplo" },
				sql = { "sql_formatter" },
				python = { "black" },

				-- Форматирование "впрыснутого" кода (SQL внутри строк в Python/JS/etc)
				["_"] = { "injected" },
			},

			formatters = {
				sql_formatter = {
					args = {
						"--language",
						"postgresql",
						"--config",
						[[{"paramTypes": {"custom": [{"regex": "@\\w+"}, {"regex": "%s"}]}}]],
					},
				},
				injected = {
					options = {
						ignore_errors = false,
						lang_to_ext = { sql = "sql" },
					},
				},
			},

			-- IMPORTANT: Make format_on_save conditional
			format_on_save = function()
				if vim.b.disable_autoformat then
					return nil -- disable formatting
				end
				return {
					lsp_format = "never",
					timeout_ms = 3000,
				}
			end,
		})

		-- Toggle command
		vim.api.nvim_create_user_command("FormatToggle", function()
			vim.b.disable_autoformat = not vim.b.disable_autoformat
			print("Autoformat: " .. (vim.b.disable_autoformat and "OFF" or "ON"))
		end, {})

		-- Keybind
		vim.keymap.set("n", "<leader>tf", "<cmd>FormatToggle<CR>", { noremap = true, silent = true })
	end,
}

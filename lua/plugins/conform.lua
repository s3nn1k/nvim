return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "injected" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				markdown = { "prettier_md", "injected" },
				yaml = { "prettier" },
				yml = { "prettier" },
				toml = { "taplo" },
				sql = { "sql_formatter" },
				python = { "black" },

				-- Форматирование "впрыснутого" кода (SQL внутри строк в Python/JS/etc)
				["_"] = { "injected" },
			},

			formatters = {
				-- Канон md-text, фаза 1 - проза: жадный перенос к 90; код-блоки prettier не
				-- трогает (их форматирует injected ниже) - иначе дефолтный prettier влезает в
				-- примеры (jsonc-запятые, отступы).
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
				-- Канон md-text, фаза 2 (injected): json/jsonc-блоки - форматировать, но без
				-- trailing-запятых (parser jsonc держит и JSON, и комментарии) и шириной 100.
				prettier_jsonc = {
					command = "prettier",
					args = {
						"--parser",
						"jsonc",
						"--trailing-comma",
						"none",
						"--print-width",
						"100",
					},
				},
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
						-- битый блок валит форматтеров громко (:ConformInfo / conform.log);
						-- чинится правкой блока и пересохранением
						ignore_errors = false,
						lang_to_ext = { sql = "sql" },
						lang_to_formatters = {
							go = { "gofmt" },
							sql = { "sql_formatter" },
							json = { "prettier_jsonc" },
							jsonc = { "prettier_jsonc" },
						},
					},
				},
			},

			-- IMPORTANT: Make format_on_save conditional
			format_on_save = function(bufnr)
				if vim.b[bufnr].disable_autoformat then
					return nil -- disable formatting
				end
				-- injected-форматтеру нужны готовые treesitter-диапазоны; сразу после старта
				-- (headless-батч, первое открытие) parse может не успеть - ждём. В
				-- интерактиве парсер уже готов, выход мгновенный.
				vim.wait(2000, function()
					local ok, parser = pcall(vim.treesitter.get_parser, bufnr)
					return ok and parser ~= nil and #parser:parse() > 0
				end)
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
		vim.keymap.set("n", "<leader>tf", "<cmd>FormatToggle<CR>", {
			noremap = true,
			silent = true,
			desc = require("package.keymaps").desc("Toggle autoformat"),
		})
	end,
}

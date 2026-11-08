return {
	"nvim-lualine/lualine.nvim",
	event = "UIEnter",
	config = function()
		local palette = require("zenbox_dark.palette")

		local function mode_block(color)
			return { fg = palette.bg, bg = color, gui = "bold" }
		end

		local function flat(fg)
			return { fg = fg, bg = palette.bg }
		end

		local theme = {
			normal = {
				a = mode_block(palette.fg),
				b = flat(palette.fg_dim),
				c = flat(palette.fg_dim),
				x = flat(palette.fg_dim),
				y = flat(palette.fg_dim),
				z = flat(palette.fg),
			},
			insert = { a = mode_block(palette.blue) },
			visual = { a = mode_block(palette.purple) },
			replace = { a = mode_block(palette.red) },
			command = { a = mode_block(palette.green) },
			terminal = { a = mode_block(palette.cyan) },
			inactive = {
				a = flat(palette.overlay1),
				b = flat(palette.overlay1),
				c = flat(palette.overlay1),
				x = flat(palette.overlay1),
				y = flat(palette.overlay1),
				z = flat(palette.overlay1),
			},
		}

		local function tab_position()
			if vim.fn.tabpagenr("$") < 2 then
				return ""
			end
			return vim.fn.tabpagenr() .. "/" .. vim.fn.tabpagenr("$")
		end

		local function macro_recording()
			local reg = vim.fn.reg_recording()
			if reg == "" then
				return ""
			end
			return " recording @" .. reg
		end

		require("lualine").setup({
			options = {
				theme = theme,
				section_separators = { left = "", right = "" },
				component_separators = { left = "│", right = "│" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"branch",
					"diff",
					"diagnostics",
					{ macro_recording, color = { fg = "#ff9e64", gui = "bold" } },
				},
				lualine_c = { { "filename", path = 0 } },
				lualine_x = { "lsp_status", "encoding", "fileformat" },
				lualine_y = { tab_position },
				lualine_z = { "progress", "location" },
			},
		})

		-- RecordingLeave срабатывает до сброса reg_recording(), перерисовываем с задержкой
		vim.api.nvim_create_autocmd("RecordingLeave", {
			group = vim.api.nvim_create_augroup("lualine-macro", { clear = true }),
			callback = function()
				vim.defer_fn(function()
					require("lualine").refresh()
				end, 50)
			end,
		})
	end,
}

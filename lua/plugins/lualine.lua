return {
	"nvim-lualine/lualine.nvim",
	event = "UIEnter",
	config = function()
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
				theme = "auto",
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

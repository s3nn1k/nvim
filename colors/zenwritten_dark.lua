if vim.g.colors_name then
	vim.api.nvim_command("highlight clear")
end

vim.o.background = "dark"
vim.g.colors_name = "zenwritten_dark"

local lush = require("lush")
local specs = require("zenburned")
local terminal_bg = "#14191f"
local terminal_bg_hl = "#1e242c"

return lush.extends({ specs }).with(function()
	return {
		Normal { specs.Normal, bg = terminal_bg },
		NormalNC { Normal },
		MsgArea { Normal },
		EndOfBuffer { specs.EndOfBuffer, bg = terminal_bg },
		LineNr { specs.LineNr, bg = terminal_bg },
		SignColumn { specs.SignColumn, bg = terminal_bg },
		FoldColumn { specs.FoldColumn, bg = terminal_bg },
		Folded { specs.Folded, bg = terminal_bg_hl },
		CursorLine { specs.CursorLine, bg = terminal_bg_hl },
		CursorColumn { CursorLine },
		ColorColumn { CursorLine },
	}
end)

local lush = require("lush")

return lush.extends({ require("zenwritten") }).with(function()
	return {
		Normal { bg = "#14191f" },
		NormalNC { Normal },
		MsgArea { Normal },
		EndOfBuffer { bg = "#14191f" },
		LineNr { bg = "#14191f" },
		SignColumn { bg = "#14191f" },
		FoldColumn { bg = "#14191f" },
		Folded { bg = "#1e242c" },
		CursorLine { bg = "#1e242c" },
		CursorColumn { CursorLine },
		ColorColumn { CursorLine },
	}
end)

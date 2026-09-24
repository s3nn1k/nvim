local M = {}

local theme_file = vim.fn.stdpath("data") .. "/theme"

M.default = "zenwritten_dark"

M.registry = {
	["zenwritten_dark"] = { lualine = "zenwritten_dark" },
	["gruvbox-material"] = { lualine = "gruvbox-material" },
	["kanagawa-wave"] = { lualine = "kanagawa" },
}

function M.active_name()
	local f = io.open(theme_file, "r")
	if not f then
		return M.default
	end
	local name = vim.trim(f:read("*l") or "")
	f:close()
	if M.registry[name] then
		return name
	end
	return M.default
end

function M.lualine()
	return M.registry[M.active_name()].lualine
end

local function apply_highlights(highlights)
	for group, opts in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, opts)
	end
end

local function zenwritten_dark_fix()
	local terminal_bg = "#14191f"
	local surface = "#1e242c"
	local float_bg = "#26282d"
	local prompt_bg = "#34373d"
	local border_fg = "#7c7f85"
	local fg_dim = "#b8bbb2"
	apply_highlights({
		Normal = { bg = terminal_bg },
		NormalNC = { link = "Normal" },
		MsgArea = { link = "Normal" },
		EndOfBuffer = { bg = terminal_bg },
		LineNr = { bg = terminal_bg },
		SignColumn = { bg = terminal_bg },
		FoldColumn = { bg = terminal_bg },
		Folded = { bg = surface },
		CursorLine = { bg = surface },
		CursorColumn = { link = "CursorLine" },
		ColorColumn = { link = "CursorLine" },
		NormalFloat = { fg = fg_dim, bg = float_bg },
		FloatBorder = { fg = border_fg, bg = float_bg },
		TelescopeTitle = { fg = fg_dim, bold = true },
		TelescopePromptNormal = { bg = prompt_bg },
		TelescopePromptBorder = { fg = prompt_bg, bg = prompt_bg },
		TelescopeResultsNormal = { fg = fg_dim, bg = float_bg },
		TelescopeResultsBorder = { fg = float_bg, bg = float_bg },
		TelescopePreviewNormal = { bg = float_bg },
		TelescopePreviewBorder = { fg = float_bg, bg = float_bg },
		NoiceCmdlinePopup = { bg = float_bg },
		NoiceCmdlineIconCmdline = { fg = fg_dim },
		NoiceCmdlinePopupBorder = { fg = border_fg },
		NoiceCmdlinePopupSearch = { bg = float_bg },
		NoiceCmdlineIconSearch = { fg = fg_dim },
		NoiceCmdlinePopupBorderSearch = { fg = border_fg },
		WhichKeyTitle = { fg = fg_dim, bg = float_bg, bold = true },
	})
end

local function gruvbox_material_fix()
	local raw = vim.fn["gruvbox_material#get_palette"]("soft", "material", vim.empty_dict())
	local function c(key)
		return raw[key][1]
	end
	apply_highlights({
		NormalFloat = { fg = c("fg1"), bg = c("bg0") },
		FloatBorder = { fg = c("grey1"), bg = c("bg0") },
		TelescopeTitle = { fg = c("fg1"), bold = true },
		TelescopePromptNormal = { bg = c("bg1") },
		TelescopePromptBorder = { fg = c("bg1"), bg = c("bg1") },
		TelescopeResultsNormal = { fg = c("fg1"), bg = c("bg0") },
		TelescopeResultsBorder = { fg = c("bg0"), bg = c("bg0") },
		TelescopePreviewNormal = { bg = c("bg0") },
		TelescopePreviewBorder = { fg = c("bg0"), bg = c("bg0") },
		NoiceCmdlinePopup = { bg = c("bg_dim") },
		NoiceCmdlineIconCmdline = { fg = c("orange") },
		NoiceCmdlinePopupBorder = { fg = c("grey1") },
		NoiceCmdlinePopupSearch = { bg = c("bg_dim") },
		NoiceCmdlineIconSearch = { fg = c("orange") },
		NoiceCmdlinePopupBorderSearch = { fg = c("grey1") },
		WhichKeyTitle = { fg = c("fg1"), bg = c("bg1"), bold = true },
	})
end

function M.post_fix(name)
	if name == "zenwritten_dark" then
		zenwritten_dark_fix()
	elseif name == "gruvbox-material" then
		gruvbox_material_fix()
	end
end

function M.switch(name)
	if not M.registry[name] then
		return
	end
	local f = io.open(theme_file, "w")
	if f then
		f:write(name)
		f:close()
	end
	vim.cmd("colorscheme " .. name)
	require("lualine").setup({ options = { theme = M.registry[name].lualine } })
end

M.specs = {
	require("themes.zenwritten_dark"),
	require("themes.gruvbox_material"),
	require("themes.kanagawa"),
}

vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("themes-post-fix", { clear = true }),
	callback = function(ev)
		M.post_fix(ev.match)
	end,
})

return M

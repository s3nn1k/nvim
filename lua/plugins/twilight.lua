return {
	"folke/twilight.nvim",
	cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
	opts = {
		dimming = { alpha = 0.25 },
		context = 10,
		treesitter = true,
	},
	config = function(_, opts)
		require("twilight").setup(opts)
		-- Twilight's get_node crashes on buffers without a treesitter parser
		-- (scratch, [No Name], neo-tree's nui split, zen-mode backdrops) because
		-- it indexes the parser unconditionally. Short-circuit when no parser
		-- exists; real buffers with parsers still go through the normal path.
		local view = require("twilight.view")
		local orig_get_node = view.get_node
		view.get_node = function(buf, ...)
			local ok, parser = pcall(vim.treesitter.get_parser, buf)
			if not ok or not parser then
				return nil
			end
			return orig_get_node(buf, ...)
		end
	end,
}

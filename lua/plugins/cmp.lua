return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{ "L3MON4D3/LuaSnip" },
		{ "saadparwaiz1/cmp_luasnip" },
	},
	config = function()
		local cmp = require("cmp")

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<C-k>"] = cmp.mapping.scroll_docs(-4),
				["<C-j>"] = cmp.mapping.scroll_docs(4),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
		})
	end,
}

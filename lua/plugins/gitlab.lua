local auth = require("package.gitlab_auth")

return {
	"harrisoncramer/gitlab.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"dlyongemallo/diffview-plus.nvim",
	},
	keys = {
		{
			"glA",
			function()
				require("gitlab").approve()
			end,
			desc = require("package.keymaps").desc("GitLab: approve MR"),
		},
		{
			"glR",
			function()
				require("gitlab").revoke()
			end,
			desc = require("package.keymaps").desc("GitLab: revoke MR approval"),
		},
		{
			"glC",
			function()
				require("gitlab").create_mr()
			end,
			desc = require("package.keymaps").desc("GitLab: create MR"),
		},
		{
			"glS",
			function()
				require("gitlab").review()
			end,
			desc = require("package.keymaps").desc("GitLab: start review for current branch"),
		},
		{
			"glQ",
			function()
				require("gitlab").close_review()
			end,
			desc = require("package.keymaps").desc("GitLab: close MR review"),
		},
		{
			"glr",
			function()
				require("gitlab").reload_review()
			end,
			desc = require("package.keymaps").desc("GitLab: reload MR review"),
		},
		{
			"gls",
			function()
				require("gitlab").summary()
			end,
			desc = require("package.keymaps").desc("GitLab: MR summary"),
		},
		{
			"gln",
			function()
				require("gitlab").create_note()
			end,
			desc = require("package.keymaps").desc("GitLab: create MR note"),
		},
	},
	opts = {
		connection_settings = {
			remote = auth.remote_name,
		},
		auth_provider = auth.auth_provider,
		keymaps = {
			help = "g?",
			global = {
				disable_all = true,
			},
			popup = {
				next_field = "<Tab>",
				prev_field = "<S-Tab>",
				perform_action = "ZZ",
				perform_linewise_action = "<Plug>(gitlab.linewise)",
				discard_changes = false,
			},
			discussion_tree = {
				switch_view = "c",
				open_in_browser = "b",
				toggle_resolved = "-",
				reply = "r",
				edit_comment = "e",
				delete_comment = "dd",
				toggle_node = "t",
				toggle_all_discussions = "T",
				jump_to_file = false,
				toggle_tree_type = false,
				refresh_data = false,
				publish_draft = false,
				print_node = false,
				add_emoji = false,
				delete_emoji = false,
				copy_node_url = false,
				jump_to_reviewer = false,
				toggle_date_format = false,
				toggle_draft_mode = false,
				toggle_sort_method = false,
				toggle_resolved_discussions = false,
				toggle_unresolved_discussions = false,
			},
			reviewer = {
				create_comment = "c",
				move_to_discussion_tree = "a",
				create_suggestion = false,
			},
		},
	},
}

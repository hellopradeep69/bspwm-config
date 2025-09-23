return {
	"cbochs/grapple.nvim",
	opts = {
		scope = "global", -- also try out "git_branch"
		icons = false, -- setting to "true" requires "nvim-web-devicons"
		status = true,
		-- style = "relative",
		style = "basename",
		-- quick_select = "qwertyuio",
		quick_select = "1234567890",
		GrappleTitle = false,
		default_scopes = {
			lsp = { hidden = true },
			git = { hidden = true },
			cwd = { hidden = true },
			static = { hidden = true },
		},
		win_opts = {
			-- Can be fractional
			width = 70,
			height = 8,
			row = 0.5,
			col = 0.5,

			relative = "editor",
			border = "single",
			focusable = false,
			style = "minimal",

			title = "Grapple", -- fallback title for Grapple windows
			title_pos = "left",
			title_padding = " ", -- custom: adds padding around window title

			footer = "", -- disable footer
			-- footer_pos = "center",
		},
	},

	keys = {
		{ "<leader>H", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
		{ "<leader>h", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

		{ "<leader>j", "<cmd>Grapple cycle_scopes next<cr>", desc = "cycle scopes" },
		{ "<c-s-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
		{ "<c-s-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
	},
}

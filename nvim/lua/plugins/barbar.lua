return {
	{
		"romgrk/barbar.nvim",
		-- event = "VeryLazy",
		init = function()
			-- Disable auto-setup so we control config
			vim.g.barbar_auto_setup = false
		end,
		opts = {
			animation = true, -- smooth tab animations
			-- auto_hide = 1, -- never auto-hide
			auto_hide = false, -- never auto-hide
			insert_at_end = true, -- new buffers go to end
			maximum_padding = 1, -- padding around buffer names
			icons = {
				-- Configure the base icons on the bufferline.
				-- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
				-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
				preset = "default",
				buffer_index = false,
				buffer_number = false,
				button = "",
				gitsigns = {
					added = { enabled = true, icon = "+" },
					changed = { enabled = true, icon = "~" },
					deleted = { enabled = true, icon = "-" },
				},
				filetype = {
					custom_colors = false,
					-- Requires `nvim-web-devicons` if `true`
					enabled = false,
				},
				separator = { left = "▎", right = "" },
				-- modified = { button = "●" },
				modified = { button = "-" },
				pinned = { button = "", filename = true },
			},
			highlight_visible = true,
			highlight_alternate = false,
			no_name_title = nil,
			-- hide = { extensions = true, inactive = true },
			-- Set the filetypes which barbar will offset itself for
			sidebar_filetypes = {
				-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
				["neo-tree"] = {
					event = "BufWipeout",
					text = "Neo-tree",
					highlight = "Directory",
					align = "left",
				},
				-- Or, specify the text used for the offset:
				undotree = {
					text = "undotree",
					align = "left", -- *optionally* specify an alignment (either 'left', 'center', or 'right')
				},
				-- Or, specify the event which the sidebar executes when leaving:
				-- ["neo-tree"] = { event = "BufWipeout" },
				-- Or, specify all three
				Outline = { event = "BufWinLeave", text = "symbols-outline", align = "right" },
			},
		},
		config = function(_, opts)
			require("barbar").setup(opts)

			local map = vim.keymap.set
			-- Buffer navigation
			map("n", "L", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
			map("n", "H", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
			map("n", "<Tab>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
			map("n", "<S-Tab>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })

			-- Buffer management
			map("n", "<leader>bc", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })
			map("n", "<leader>bp", "<Cmd>BufferPin<CR>", { desc = "Pin buffer" })
			map("n", "<leader>bn", "<Cmd>BufferMoveNext<CR>", { desc = "Move buffer right" })
			map("n", "<leader>bb", "<Cmd>BufferMovePrevious<CR>", { desc = "Move buffer left" })
		end,
	},
}

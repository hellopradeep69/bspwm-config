return {
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
			"folke/lazydev.nvim",
			-- { "L3MON4D3/LuaSnip", version = "v2.*" },
		},
		version = "1.*",

		opts = {

			-- snippets = { preset = "luasnip" },
			-- disable in Neo-tree and other special buffers
			enabled = function()
				local disabled_filetypes = { "neo-tree", "TelescopePrompt", "help" }
				local ft = vim.bo.filetype
				if vim.tbl_contains(disabled_filetypes, ft) then
					return false
				end
				return true
			end,

			keymap = {
				preset = "enter",
				["<C-y>"] = { "select_and_accept" },
			},

			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			-- cmdline disable
			cmdline = {
				enabled = true,
			},

			-- cmdline enable
			-- cmdline = {
			-- 	enabled = true,
			-- 	keymap = { preset = "cmdline" },
			-- 	completion = {
			-- 		list = { selection = { preselect = false } },
			-- 		menu = {
			-- 			auto_show = function(ctx)
			-- 				return vim.fn.getcmdtype() == ":"
			-- 			end,
			-- 		},
			-- 		ghost_text = { enabled = true },
			-- 	},
			-- },

			signature = { enabled = true },

			completion = {
				list = { selection = { preselect = true, auto_insert = false } },
				trigger = { show_on_insert = false, prefetch_on_insert = true },
				accept = { auto_brackets = { enabled = true } },
				menu = {
					scrollbar = false,
					-- border = "rounded",
					auto_show = true,
					auto_show_delay_ms = 0,
					draw = { treesitter = { "lsp" } },
				},
				documentation = {
					window = {
						min_width = 10,
						max_width = 80,
						max_height = 20,
						-- border = "rounded",
					},
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = { enabled = vim.g.ai_cmp },
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink", -- 👈 tells blink to use lazydev
					},
				},
			},

			fuzzy = { implementation = "prefer_rust_with_warning" },
		},

		opts_extend = { "sources.default" },
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load for Lua files
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "lua", words = { "vim" } },
			},
		},
	},
}

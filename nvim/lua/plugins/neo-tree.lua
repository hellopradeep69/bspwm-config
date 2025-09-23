return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	cmd = "Neotree",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons", -- optional, for icons
	},
	keys = {
		-- Open in project root (fallback to cwd if no LSP root)
		{
			"<leader>fe",
			function()
				local file_dir = vim.fn.expand("%:p:h:h") -- parent directory of current file
				-- local file_dir = vim.fn.expand("%:p:h") -- parent directory of current file
				require("neo-tree.command").execute({ toggle = true, dir = file_dir })
			end,
			desc = "Explorer NeoTree (File Dir)",
		},
		-- {
		-- 	"<leader>e",
		-- 	"<cmd>Neotree filesystem reveal left toggle<CR>",
		-- 	desc = "Open neo tree",
		-- },
		-- Open in current working directory
		{
			"<leader>fE",
			function()
				require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
			end,
			desc = "Explorer NeoTree (cwd)",
		},
		{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Project Root)", remap = true },
		-- { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },

		-- Git and buffers
		{
			"<leader>ge",
			function()
				require("neo-tree.command").execute({ source = "git_status", toggle = true })
			end,
			desc = "Git Explorer",
		},
		-- {
		-- "<leader>bb", <cmd>Neotree buffers float toggle<CR>, desc = "buffers neo-tree"
		-- },
		{
			"<leader>pb",
			function()
				require("neo-tree.command").execute({ source = "buffers", toggle = true, position = "float" })
			end,
			desc = "Buffer Explorer",
		},

		-- Close tree
		{ "<leader>q", "<cmd>Neotree close<cr>", desc = "Close NeoTree" },
	},

	deactivate = function()
		vim.cmd([[Neotree close]])
	end,

	init = function()
		-- Auto-load Neo-tree if Neovim starts with a directory
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Neo-tree with directory",
			once = true,
			callback = function()
				if not package.loaded["neo-tree"] then
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("neo-tree")
					end
				end
			end,
		})
	end,

	opts = function(_, opts)
		opts.sources = { "filesystem", "buffers", "git_status" }
		opts.open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" }

		opts.filesystem = {
			bind_to_cwd = true,
			follow_current_file = { enabled = true },
			use_libuv_file_watcher = true,
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = false,
			},
		}

		opts.window = {
			position = "left",
			width = 30,
			mappings = {
				["l"] = "open",
				["h"] = "close_node",
				["<space>"] = "none",
				["Y"] = {
					function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						vim.fn.setreg("+", path, "c")
					end,
					desc = "Copy Path to Clipboard",
				},
				["O"] = {
					function(state)
						vim.ui.open(state.tree:get_node().path) -- plain Neovim replacement
					end,
					desc = "Open with System Application",
				},
				["P"] = { "toggle_preview", config = { use_float = true } },
			},
		}

		opts.default_component_configs = {
			indent = {
				with_expanders = true,
				expander_collapsed = "",
				expander_expanded = "",
				expander_highlight = "NeoTreeExpander",
			},
			git_status = {
				symbols = {
					unstaged = "󰄱",
					staged = "󰱒",
				},
			},
		}

		return opts
	end,

	config = function(_, opts)
		local events = require("neo-tree.events")

		-- Replace Snacks rename with simple notify
		local function on_move(data)
			vim.notify("File moved: " .. data.source .. " → " .. data.destination)
		end

		opts.event_handlers = opts.event_handlers or {}
		vim.list_extend(opts.event_handlers, {
			{ event = events.FILE_MOVED, handler = on_move },
			{ event = events.FILE_RENAMED, handler = on_move },
		})

		require("neo-tree").setup(opts)

		-- Refresh git status after lazygit closes
		vim.api.nvim_create_autocmd("TermClose", {
			pattern = "*lazygit",
			callback = function()
				if package.loaded["neo-tree.sources.git_status"] then
					require("neo-tree.sources.git_status").refresh()
				end
			end,
		})
	end,
}

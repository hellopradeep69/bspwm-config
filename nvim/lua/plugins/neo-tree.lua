return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional but recommended
  },
  keys = {
    -- LazyVim defaults
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
      end,
      desc = "Explorer NeoTree (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },

    -- Extra custom mappings
    -- { "<leader>t", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    -- { "<leader>r", "<cmd>Neotree filesystem reveal<cr>", desc = "Reveal File in Neo-tree" },

    -- {
    --   "<leader>r",
    --   function()
    --     require("neo-tree.command").execute({
    --       toggle = true, -- toggle open/close
    --       dir = vim.loop.cwd(), -- current working directory
    --       reveal_file = false, -- do NOT try to reveal the current file
    --       position = "left", -- optional: position of the tree
    --     })
    --   end,
    --   desc = "Explorer Neo-tree (cwd only)",
    -- },
    { "<leader>q", "<cmd>Neotree close<cr>", desc = "Close NeoTree" },
    -- {
    --   "<leader>o",
    --   function()
    --     if vim.bo.filetype == "neo-tree" then
    --       vim.cmd("wincmd p")
    --     else
    --       vim.cmd("Neotree reveal")
    --     end
    --   end,
    --   desc = "Toggle focus NeoTree / File",
    -- },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    -- Lazy-load Neo-tree if starting with a directory
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
    -- opts.close_if_last_window = true -- Close Neo-tree if it is the last window left in the tab
    opts.sources = { "filesystem", "buffers", "git_status" }
    opts.open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" }

    opts.filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true, -- show hidden files
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    }

    opts.window = {
      position = "left", -- left, right, top, bottom, float, current
      width = 27, -- applies to left and right positions
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
            require("lazy.util").open(state.tree:get_node().path, { system = true })
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
    local function on_move(data)
      Snacks.rename.on_rename_file(data.source, data.destination)
    end

    local events = require("neo-tree.events")
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

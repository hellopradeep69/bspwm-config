return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = function(_, opts)
    -- merge your changes into LazyVim’s defaults
    opts.sources = { "filesystem", "buffers", "git_status" }
    opts.open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" }

    opts.filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = true, -- show hidden files (dotfiles)
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    }

    opts.window = {
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
        ["P"] = { "toggle_preview", config = { use_float = false } },
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
}

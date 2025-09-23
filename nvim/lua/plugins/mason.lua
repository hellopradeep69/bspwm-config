
return {
  "mason-org/mason.nvim",
  lazy = false, -- load immediately
  keys = {
    { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
  },
  dependencies = {
    { "mason-org/mason-lspconfig.nvim", config = function() end },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = { "stylua", "shfmt" }, -- mason tools
    servers = { "lua_ls", "pyright", "html", "cssls", "clangd" }, -- LSP servers
  },
  config = function(_, opts)
    local mason = require("mason")
    local mr = require("mason-registry")
    local mlsp = require("mason-lspconfig")

    -- Setup mason
    mason.setup(opts)

    -- Auto-install mason tools
    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)

    -- Auto-install LSP servers
    mlsp.setup({
      ensure_installed = opts.servers,
      automatic_installation = true,
    })

    -- Configure servers
    for _, server in ipairs(opts.servers) do
      -- Example of server-specific config
      if server == "lua_ls" then
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              hint = { enable = true },
            },
          },
        })
      else
        vim.lsp.config(server, {}) -- default config
      end

      -- Enable server (activates for its filetypes)
      vim.lsp.enable(server)
    end

    -- Optional: re-trigger FileType after installs
    mr:on("package:install:success", function()
      vim.defer_fn(function()
        vim.cmd("doautocmd FileType")
      end, 100)
    end)
  end,
}

return {
  "brianhuster/live-preview.nvim",
  dependencies = {
    -- You can choose one of the following pickers
    -- "nvim-telescope/telescope.nvim",
    -- "ibhagwan/fzf-lua",
    --       'echasnovski/mini.pick',
    "folke/snacks.nvim",
  },
  keys = {
    { "<leader>pp", "<cmd>LivePreview start<cr>", desc = "live preview" },
    { "<leader>px", "<cmd>LivePreview close<cr>", desc = "live preview close" },
    -- {
    --   "<leader>pp",
    --   function()
    --     vim.cmd("LivePreview start" .. vim.fn.expand("%:p"))
    --   end,
    --   desc = "live preview current file",
    -- },
  },
  event = { "BufRead *.html", "BufRead *.md", "BufRead *.css" },
}

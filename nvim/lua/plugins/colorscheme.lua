-- return {
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "custom", -- use your scheme
--     },
--   },
-- }
-- return {
--   -- add gruvbox
--   { "ellisonleao/gruvbox.nvim" },
--
--   -- Configure LazyVim to load gruvbox
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "gruvbox",
--     },
--   },
-- }
-- another gruvbox colorscheme (personal liking)
-- lua/plugins/gruvbox.lua
return {
  "https://gitlab.com/motaz-shokry/gruvbox.nvim",
  name = "gruvbox",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme gruvbox-hard")
  end,
}
-- idk
-- return {
--   "bluz71/vim-moonfly-colors",
--   name = "moonfly",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd("colorscheme moonfly")
--   end,
-- }
-- monochrome theme colorscheme
-- return {
--   "kdheepak/monochrome.nvim",
--   name = "monochrome",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     vim.cmd("colorscheme monochrome")
--   end,
-- }

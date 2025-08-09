-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- jj as an escape
vim.keymap.set("i", "jj", "<Esc>", { desc = "jj to escape insert mode" })

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Don't copy to clipboard when deleting
map("n", "d", '"_d', opts)
map("n", "dd", '"_dd', opts)
map("n", "x", '"_x', opts)
map("v", "d", '"_d', opts)
map("v", "x", '"_x', opts)

-- Optional: still allow yanking to clipboard
map("n", "<leader>y", '"+y', opts)
map("v", "<leader>y", '"+y', opts)

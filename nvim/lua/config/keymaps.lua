-- Add any additional keymaps here
-- jj as an escape
vim.keymap.set("i", "jj", "<Esc>", { desc = "jj to escape insert mode" })
vim.o.timeoutlen = 300

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", "<leader>o", "<C-w>w", { desc = "toggle Window", noremap = true, silent = false })
map("n", "<leader>dd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
-- Don't copy to clipboard when deleting
map("n", "d", '"_d', opts)
map("n", "dd", '"_dd', opts)
map("n", "x", '"_x', opts)
map("v", "d", '"_d', opts)
map("v", "x", '"_x', opts)

-- Optional: still allow yanking to clipboard
map("n", "<leader>y", '"+y', opts)
map("v", "<leader>y", '"+y', opts)

-- move stuff easily
map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Normal mode: <leader>sr opens :%s/
vim.keymap.set("n", "<leader>r", ":%s/", { desc = "Search and Replace" })
-- vim.keymap.set("c", "jj", "<Esc>", { desc = "Abort command-line" })
-- vim.keymap.set("n", "<leader>sr", ":%s///gc<Left><Left>", { desc = "Search and Replace (global)" })

-- map("n", "<leader>dd", function()
--   Snacks.bufdelete()
-- end, { desc = "Delete Buffer" })
--

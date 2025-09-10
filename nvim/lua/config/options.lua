-- OPTIONS CONFIGURATION FOR LazyVim
-- This file sets custom Vim options before LazyVim startup.
-- Default options: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

vim.opt.cmdheight = 0
-- GENERAL SETTINGS
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.ruler = true -- Show the cursor position all the time
vim.opt.showcmd = true -- Show (partial) command in the last line of the screen
vim.opt.cursorline = true -- Highlight the current line
vim.opt.termguicolors = true -- Enable true color support
vim.opt.mouse = "" -- Disable mouse support
-- vim.opt.colorcolumn = "80"

-- FILE AND BACKUP SETTINGS
vim.opt.swapfile = false -- Don't use swap files
vim.opt.undofile = true -- Save undo history to file
-- vim.opt.backup = false          -- Optional: disable backup files (commented out)
-- vim.opt.nowritebackup = true -- Don't make a backup before overwriting a file

-- SEARCH SETTINGS
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override 'ignorecase' if search pattern contains uppercase letters
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show search matches as you type

-- INDENTATION AND TABS
vim.opt.smartindent = true -- Make indenting smarter
vim.opt.tabstop = 4 -- Number of spaces per tab
vim.opt.shiftwidth = 4 -- Number of spaces for autoindent
vim.opt.expandtab = true -- Convert tabs to spaces

-- WRAPPING AND SCROLLING
vim.opt.wrap = true -- Enable line wrapping
vim.opt.scrolloff = 8 -- Minimum number of screen lines above/below the cursor
vim.opt.sidescrolloff = 8 -- Minimum number of columns to the left/right of the cursor

-- UI AND INTERFACE
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.showmatch = true -- Briefly jump to matching bracket
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.laststatus = 2 -- Always display the status line

-- TIMING
vim.opt.timeoutlen = 500 -- Time to wait for a mapped sequence (in ms)
vim.opt.ttimeoutlen = 0 -- Time to wait for a key code sequence (faster responsiveness)

-- vim.cmd.colorscheme("default") -- example theme

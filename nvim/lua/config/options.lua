-- OPTIONS CONFIGURATION FOR

vim.opt.confirm = true --
vim.opt.cmdheight = 0
vim.opt.showmode = false
-- GENERAL SETTINGS
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.ruler = true -- Show the cursor position all the time
vim.opt.showcmd = true -- Show (partial) command in the last line of the screen
vim.opt.cursorline = true -- Highlight the current line
-- vim.opt.guicursor = ""
vim.opt.termguicolors = true -- Enable true color support
vim.opt.mouse = "" -- Disable mouse support
vim.opt.colorcolumn = "85"

-- FILE AND BACKUP SETTINGS
vim.opt.swapfile = false -- Don't use swap files
vim.opt.undofile = true -- Save undo history to file
vim.opt.undolevels = 10000
-- vim.opt.backup = false          -- Optional: disable backup files (commented out)
-- vim.opt.nowritebackup = true -- Don't make a backup before overwriting a file

-- SEARCH SETTINGS
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override 'ignorecase' if search pattern contains uppercase letters
vim.opt.hlsearch = true -- Highlight search matches
vim.opt.incsearch = true -- Show search matches as you type

-- INDENTATION AND TABS
vim.cmd([[filetype plugin indent on]])
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smartindent = true -- Make indenting smarter
vim.opt.tabstop = 4 -- Number of spaces per tab
vim.opt.shiftwidth = 4 -- Number of spaces for autoindent
vim.opt.expandtab = true -- Convert tabs to spaces

-- WRAPPING AND SCROLLING
vim.opt.wrap = true -- Enable line wrapping
vim.opt.scrolloff = 8 -- Minimum number of screen lines above/below the cursor
vim.opt.sidescrolloff = 8 -- Minimum number of columns to the left/right of the cursor

-- UI AND INTERFACE
vim.opt.winborder = "rounded"
-- vim.opt.winborder = "single"
-- vim.o.winborder="+,-,+,|,+,-,+,|"
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.showmatch = true -- Briefly jump to matching bracket
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.laststatus = 2 -- Always display the status line

-- TIMING
vim.opt.timeoutlen = 500 -- Time to wait for a mapped sequence (in ms)
vim.opt.ttimeoutlen = 0 -- Time to wait for a key code sequence (faster responsiveness)

vim.opt.background = "dark"
-- vim.cmd.colorscheme("default") -- example theme
--
-- it fill idk but file stuff
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

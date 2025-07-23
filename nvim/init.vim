" Load vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" Auto-pairs plugin
Plug 'jiangmiao/auto-pairs'

" End plugin section
call plug#end()

" Enable line numbers
set number

" Enable relative line numbers
set relativenumber

" Enable syntax highlighting
syntax on

" Set tab width
set tabstop=4
set shiftwidth=4
set expandtab

" Use system clipboard
set clipboard=unnamedplus

set mouse=

" adding new stuff
" Show line and column number in the status line
set ruler

" Highlight current line
set cursorline

" Show matching brackets when cursor is on one
set showmatch

" Keep some lines visible when scrolling
set scrolloff=8
set sidescrolloff=8

" Enable line wrapping (disable with nowrap)
set wrap

" Smart indenting for code
set smartindent

" Show partial command in the bottom right corner
set showcmd

" Don't create backup or swap files
set nobackup
set nowritebackup
set noswapfile

" Enable undo even after you close and reopen files
set undofile

" Ignore case when searching
set ignorecase

" But make it smart: if you use capital letters, match case
set smartcase

" Highlight search results
set hlsearch

" Show matches while typing
set incsearch

" Set nicer color scheme (if you have one installed)
"colorscheme industry " (try 'evening', 'gruvbox', or install one with a plugin manager)

" Always show status line
set laststatus=2

" Show line numbers and signs in a separate column
set signcolumn=yes

" Reduce delay after pressing Escape
set timeoutlen=500
set ttimeoutlen=0

" Faster scrolling
set lazyredraw 

"jj as a esvalpe
inoremap jj <Esc>

"just welcome note and welcome and stuff
autocmd BufReadPost ~/scratchpad.md echohl String | echom "Welcome back to your notes!" | echohl None
"autocmd BufReadPost ~/scratchpad.md  hi Normal guibg=#002b00 guifg=#aaffaa
autocmd BufReadPost ~/scratchpad.md hi Normal guibg=#1e1e2e guifg=#cdd6f4

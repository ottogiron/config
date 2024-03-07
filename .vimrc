" Set leader key
let mapleader = ","

" Basic editing configurations
set nocompatible              " Disable vi compatibility mode
set backspace=indent,eol,start " Make backspace work over everything in insert mode
set autoindent                " Enable auto-indent
set smartindent               " Enable smart indent
set tabstop=4                 " Set tab width to 4 spaces
set shiftwidth=4              " Set auto-indent width to 4 spaces
set expandtab                 " Convert tabs to spaces
set softtabstop=4             " Soft tab stops at 4 spaces
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set wrap                      " Enable line wrap
set scrolloff=5               " Minimal number of screen lines to keep above and below the cursor
set sidescrolloff=5           " Minimal number of screen columns to keep to the left and right of the cursor
set cursorline                " Highlight the current line
set incsearch                 " Incremental search
set hlsearch                  " Highlight search results
set ignorecase                " Case insensitive searching...
set smartcase                 " ... unless query contains uppercase characters
set wildmenu                  " Visual autocomplete for command menu
set showmatch                 " Show matching brackets

" Visual and performance improvements
set lazyredraw                " Improve performance by not redrawing during macros
set ttyfast                   " Speed up scrolling in Vim

" Clipboard to use system clipboard
set clipboard=unnamedplus

" Mappings for saving and quitting
nnoremap <C-s> :w<CR>          " Ctrl+S to save
nnoremap <C-q> :q<CR>          " Ctrl+Q to quit
inoremap <C-s> <Esc>:w<CR>i    " Ctrl+S to save in insert mode
inoremap <C-q> <Esc>:q<CR>i    " Ctrl+Q to quit in insert mode

" Enable filetype plugins
filetype plugin indent on

" Remove search highlight with leader+space
nnoremap <leader><space> :nohlsearch<CR>

" Additional mappings and configurations can be handled in init.lua for Neovim specific setups
" Remember to source this file if necessary or replicate configurations in init.lua for Neovim

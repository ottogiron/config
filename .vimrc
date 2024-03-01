call plug#begin('~/.vim/bundle')
call plug#end()
set ttyfast

set clipboard=unnamedplus


" Mapping Configuration
" This comes first, because we have mappings that depend on leader
" With a map leader it's possible to do extra key combinations
" i.e: <leader>w saves the current file
let mapleader = ","
" Start with basic settngs
" Set Vim-specific options (use :help option-name to find out more about each)
set nocompatible              " Disable vi compatibility mode
set backspace=indent,eol,start " Make backspace work over everything in insert mode
set autoindent                " Enable auto-indent
set smartindent               " Enable smart indent
set tabstop=4                 " Set tab to 4 spaces
set shiftwidth=4              " Set number of auto-indent spaces
set expandtab                 " Use spaces instead of tabs
set softtabstop=4             " Set number of spaces per Tab press
set number                    " Show line numbers
set relativenumber            " Show relative line numbers
set wrap                      " Enable line wrap
set scrolloff=5               " Keep at least 5 lines above/below
set sidescrolloff=5           " Keep at least 5 lines left/right
set cursorline                " Highlight the current line
set incsearch                 " Incremental search that shows partial matches
set hlsearch                  " Highlight all search matches (use :noh to turn off temporarily)
set ignorecase                " Case insensitive searching
set smartcase                 " Case sensitive if upper case is included
set wildmenu                  " Visual autocomplete for command menu
set lazyredraw                " Don't redraw while executing macros (good performance config)
set showmatch                 " Show matching brackets when text indicator is over them
set matchtime=2               " Tenths of a second to show the matching parenthesis

" Visual options
syntax on                     " Syntax highlighting
colorscheme default           " Set colorscheme (substitute with your favorite colorscheme)
set background=dark           " Tell vim what the background color looks like
set t_Co=256                  " Use 256 colors - this is important for some colorschemes

" Useful shortcuts
nnoremap <C-S> :w<CR>         " Ctrl+S saves the file
nnoremap <C-Q> :q<CR>         " Ctrl+Q quits the file
inoremap <C-S> <Esc>:w<CR>i   " Ctrl+S saves the file from insert mode
inoremap <C-Q> <Esc>:q<CR>i   " Ctrl+Q quits the file from insert mode

" Enable file type detection
filetype on
filetype indent on
filetype plugin on

" For plugins (if installed)
"call plug#begin('~/.vim/plugged')
" Plug 'tpope/vim-sensible'
" Plug 'preservim/nerdtree'
"call plug#end()

" More advanced mappings and commands can go here

" Remember, after making changes to your .vimrc, reload it with:
" :source $MYVIMRC
" Or just restart vim.

" For more details on any of these settings, use the :help command, e.g.
" :help scrolloff
"end with basic settings

" Some useful quickfix shortcuts for quickfix
nnoremap <leader>a :cclose<CR>


" Fast saving
nnoremap <leader>w :w!<cr>
nnoremap <silent> <leader>q :q!<CR>

" Center the screen
nnoremap <space> zz

" Remove search highlight
 nnoremap <leader><space> :nohlsearch<CR>
function! s:clear_highlight()
  let @/ = ""
  call go#guru#ClearSameIds()
endfunction
nnoremap <silent> <leader><space> :<C-u>call <SID>clear_highlight()<CR>

" Better split switching
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Kill job and close terminal window
tnoremap <Leader>q <C-w><C-C><C-w>c<cr>

" switch to normal mode with esc
tnoremap <Esc> <C-W>N

" mappings to move out from terminal to other views
tnoremap <C-h> <C-w>h
tnoremap <C-j> <C-w>j
tnoremap <C-k> <C-w>k
tnoremap <C-l> <C-w>l

" Open terminal in vertical, horizontal and new tab

nnoremap <leader>tv :vsplit<CR>:term<CR>
nnoremap <leader>ts :split<CR>:term<CR>
nnoremap <leader>tt :tabnew<CR>:term<CR>

tnoremap <leader>tv <C-\><C-n>:vsplit<CR>:term<CR>
tnoremap <leader>ts <C-\><C-n>:split<CR>:term<CR>



" Visual linewise up and down by default (and use gj gk to go quicker)
noremap <Up> gk
noremap <Down> gj
noremap j gj
noremap k gk

" Exit on j
imap jj <Esc>

" Source (reload configuration)
nnoremap <F3> :source ~/.vimrc<CR>

" Toggle Spell 
nnoremap <F4> :setlocal spell! spell?<CR>

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
 nnoremap n nzzzv
 nnoremap N Nzzzv

" Same when moving up and down
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

" Do not show stupid q: window
map q: :q



" Plugins Configuration

" ==================== NerdTree ====================
" For toggling
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

" Start NERDTree, unless a file or session is specified, eg. vim -S session_file.vim.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') && v:this_session == '' | NERDTree | endif

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" CtrlP search config
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows
set wildignore+=node_modules,*.git,*.hg,*.svn "

" Java 
set wildignore+=*.class,*.jar,*.war,*.ear,*.zip,*.tar.gz,*.tar.bz2,*.rar,*.pyc,*.o,*.a,*.so,*.dll,*.exe,*.obj,*.lib,*.ncb,*.sdf,*.suo,*.pdb,*.idb,*.ilk,*.aps,*.pch,*.res,*.tlb,*.tlh,*.bak,*.swp,*.bak,*.d,*.dSYM,*.class,*.jar,*.war

" Java target dir
set wildignore+=target,build,bin,classes,lib

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|node_modules|vendor)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ }



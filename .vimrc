" Plugins
call plug#begin('~/.vim/plugged')
Plug 'nightsense/vimspectr'
Plug 'junegunn/vader.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'valloric/youcompleteme' " updated Vim version needed
call plug#end()

syntax on

set nocompatible

set background=dark

let g:gruvbox_italic=0
let g:gruvbox_contrast_dark='dark'
colorscheme gruvbox

set number
set autoindent
set smartindent

set tabstop=4
set softtabstop=0
set expandtab
set shiftwidth=4
set smarttab

set ruler
set showcmd
filetype plugin indent on
set wildmenu
" set showmatch " highlight matching parens ect..
set incsearch " search as characters are entered
set hlsearch " highlight matches

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR> 
" a.k.a \<space>
set foldenable " enable code folding
set foldlevelstart=10 " open most folds by default
set foldnestmax=10 " 10 nested fold max

" space open/closes folds
nnoremap <space> za
set foldmethod=indent " fold based on indent level
set lazyredraw


set nocompatible

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'nightsense/vimspectr'
Plug 'junegunn/vader.vim'
Plug 'junegunn/seoul256.vim'
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'phanviet/vim-monokai-pro'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'valloric/youcompleteme' " updated Vim version needed
Plug 'scrooloose/nerdtree'
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
call plug#end()

syntax on

set background=dark

"let g:gruvbox_italic=0
"let g:gruvbox_contrast_dark='hard'
"let g:gruvbox_contrast_light='hard'
"colorscheme gruvbox
set termguicolors
color monokai_pro

set number
set relativenumber
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
set backspace=2 " Make backspace work list most other programs
set belloff=all

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

" Mappings for vim pane navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Nerd tree mapping
map <C-n> :NERDTreeToggle<CR>

" Background toggling function
func! BackgroundToggle()
    if (&background == "dark")
        " :MyColorscheme PaperColor
        :MyColorscheme seoul256
        set background=light
    else
        set background=dark
        " :MyColorscheme gruvbox
        :MyColorscheme monokai_pro
    endif
endfunc

nnoremap <expr> <C-T> BackgroundToggle()

" Fixes highlight group bug
" https://github.com/altercation/solarized/issues/102
if !exists('s:known_links')
  let s:known_links = {}
endif

function! s:Find_links() " {{{1
  " Find and remember links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx links to Constant" in the
    " output of the :highlight command.
    if len(tokens) == 5 && tokens[1] == 'xxx' && tokens[2] == 'links' && tokens[3] == 'to'
      let fromgroup = tokens[0]
      let togroup = tokens[4]
      let s:known_links[fromgroup] = togroup
    endif
  endfor
endfunction

function! s:Restore_links() " {{{1
  " Restore broken links between highlighting groups.
  redir => listing
  try
    silent highlight
  finally
    redir END
  endtry
  let num_restored = 0
  for line in split(listing, "\n")
    let tokens = split(line)
    " We're looking for lines like "String xxx cleared" in the
    " output of the :highlight command.
    if len(tokens) == 3 && tokens[1] == 'xxx' && tokens[2] == 'cleared'
      let fromgroup = tokens[0]
      let togroup = get(s:known_links, fromgroup, '')
      if !empty(togroup)
        execute 'hi link' fromgroup togroup
        let num_restored += 1
      endif
    endif
  endfor
endfunction

function! s:AccurateColorscheme(colo_name)
  call <SID>Find_links()
  exec "colorscheme " a:colo_name
  call <SID>Restore_links()
endfunction

command! -nargs=1 -complete=color MyColorscheme call <SID>AccurateColorscheme(<q-args>)

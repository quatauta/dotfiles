" We use a vim
set nocompatible

if has("gui_win32")
  set runtimepath+=~/.vim
endif

if &t_Co >= 256 || has("gui_running")
  colorscheme inkpot
  let &guicursor = &guicursor . ",a:blinkon0"
endif

if &t_Co > 2 || has("gui_running")
  syntax on
endif

if has("gui_running")
  gui
  set cursorline
endif

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

set autoindent
set autoread
set autowrite
set backspace=indent,eol,start
set backupdir=~/.vim/_tmp
set cmdheight=2
set copyindent
set directory=~/.vim/_tmp
set endofline
set expandtab
set formatoptions=12cjlmnoqrt
set guifont=Source\ Code\ Pro\ 9
set guioptions=acgLmrt
set hidden
set history=50
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set linebreak
set matchpairs=
set modeline
set modelines=20
set mouse=a
set mousemodel=popup_setpos
set nobackup
set nobomb
set nofoldenable
set nojoinspaces
set noswapfile
set number
set printoptions=number:y
set printoptions=paper:A4,left:15mm,right:8mm,top:8mm,bottom:8mm,syntax:y,number:y,wrap:y
set ruler
set scrolloff=8
set shiftround
set shiftwidth=4
set smartcase
set smartindent
set smarttab
set softtabstop=4
set switchbuf+=useopen,usetab
set tabstop=8
set title
set textwidth=90
set undodir=~/.vim/_tmp
set undofile
set undolevels=1000
set virtualedit=block
set wildmenu
set wildmode=list:full

if has("gui_win32")
  set guifont=Consolas:h9:cANSI
endif

filetype plugin indent on

function! HashCompletePrev()
    if getline('.') =~ '\%' . (col('.') - 1) . 'c.\>'
        return "\<C-P>"
    else
        return "#"
    endif
endfunction

map! # <C-R>=HashCompletePrev()<CR>

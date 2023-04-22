" We use a vim
set nocompatible

if has("gui_win32")
  set runtimepath+=~/.vim
endif

if &t_Co >= 256 || has("gui_running")
  " colorscheme inkpot
  let &guicursor = &guicursor . ",a:blinkon0"
  set cursorline
endif

if &t_Co > 2 || has("gui_running")
  syntax on
endif

if has("gui_running")
  gui
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
set background=
set backspace=indent,eol,start
"set bg=dark
set cmdheight=2
set copyindent
set endofline
set expandtab
set formatoptions=12cjlmnoqrt
set guifont=Fira\ Code\ 11
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
set path+=**
"set printoptions=number:y
"set printoptions=paper:A4,left:15mm,right:8mm,top:8mm,bottom:8mm,syntax:y,number:y,wrap:y
set ruler
set scrolloff=8
set shiftround
set shiftwidth=4
set shortmess+=c
set signcolumn=number
set smartcase
set smartindent
set smarttab
set softtabstop=4
set switchbuf+=useopen,usetab
set tabstop=8
set termguicolors
set textwidth=120
set title
set updatetime=300
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

" https://github.com/junegunn/vim-plug
" Make sure you use single quotes
" To update: reload ~/.vimrc and :PlugInstall
call plug#begin()
  Plug 'NLKNguyen/papercolor-theme'
  Plug 'uloco/bluloco.nvim'
  Plug 'rktjmp/lush.nvim'

  Plug 'dense-analysis/ale'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'elixir-editors/vim-elixir'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'kassio/neoterm'
  Plug 'mfussenegger/nvim-dap'
  Plug 'mfussenegger/nvim-lint'
  Plug 'neovim/nvim-lspconfig'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-rails'
  Plug 'vim-ruby/vim-ruby'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  Plug 'vim-test/vim-test'
  let test#strategy = "neoterm"

  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'elixir-lsp/coc-elixir', {'do': 'yarn install && yarn prepack'}
call plug#end()

if &t_Co >= 256 || has("gui_running")
  :lua require("bluloco")

  colorscheme PaperColor
" colorscheme bluloco
  let &guicursor = &guicursor . ",a:blinkon0"
endif

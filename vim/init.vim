set runtimepath+=$HOME/.config/nvim/autoload

call plug#begin('$HOME/.config/nvim/plugins')
    Plug 'romainl/flattened'
    Plug 'Shougo/deoplete.nvim'
    Plug 'zchee/deoplete-jedi'
    "Plug 'Yggdroot/indentLine'
    Plug 'scrooloose/nerdcommenter'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'simnalamburt/vim-mundo'
    Plug 'luochen1990/rainbow'
    Plug 'haya14busa/incsearch.vim'
    Plug 'terryma/vim-multiple-cursors'
    Plug 'racer-rust/vim-racer'
    Plug 'ambv/black'
call plug#end()

filetype plugin indent on
syntax enable

set number
set textwidth=0
set wrapmargin=0

set laststatus=2
"set term=screen
set t_Co=256
colorscheme flattened_dark
let g:airline_powerline_fonts = 1

let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " remove completion window
let mapleader =','

set ruler
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set autoindent
set smartindent

set incsearch
set hlsearch
set ignorecase
map /  <Plug>(incsearch-forward)

nnoremap <silent> <leader><space> :nohlsearch<CR>
vmap <silent> <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>

nnoremap <silent> <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

inoremap kj <Esc>
nnoremap ; :
nnoremap <silent> u :MundoToggle<CR>

nnoremap <silent> <C-j> :m .+1<CR>==
nnoremap <silent> <C-k> :m .-2<CR>==
inoremap <silent> <C-j> <Esc>:m .+1<CR>==gi
inoremap <silent> <C-k> <Esc>:m .-2<CR>==gi
vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
vnoremap <silent> <C-k> :m '<-2<CR>gv=gv

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

set hidden
let g:racer_cmd = "~Aaditya/.cargo/bin/racer"
let g:racer_experimental_completer = 1
"au FileType rust nmap gd <Plug>(rust-def)
"au FileType rust nmap gs <Plug>(rust-def-split)
"au FileType rust nmap gx <Plug>(rust-def-vertical)
"au FileType rust nmap <leader>gd <Plug>(rust-doc)

let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 1
"let g:indentLine_setColors = 0

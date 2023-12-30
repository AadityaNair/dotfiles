set runtimepath+=$INSTALL/nvim/autoload
"TODO: Check out folke/lazy.nvim
set guicursor=
call plug#begin('$INSTALL/nvim/plugins')
    Plug 'Shougo/deoplete.nvim'
    " Plug 'deoplete-plugins/deoplete-jedi'
    Plug 'easymotion/vim-easymotion'
    Plug 'luochen1990/rainbow'
    Plug 'mbbill/undotree'
    Plug 'romainl/flattened'
    Plug 'scrooloose/nerdcommenter'
    " Plug 'terryma/vim-multiple-cursors'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    " Plug 'dense-analysis/ale'
    " Plug 'chrisbra/csv.vim'
    " Plug 'Shougo/denite.nvim'
    " Plug 'robbles/logstash.vim'
call plug#end()
filetype plugin indent on
syntax enable

"""""""""""""""""""""""""""""""""""""" PLUGIN OPTIONS

" Airline
let g:airline_powerline_fonts = 1

" Ale
" let g:ale_use_global_executables = 1
" let g:ale_python_black_use_global = 1
" let g:ale_python_black_change_directory = 1
" let g:airline#extensions#ale#enabled = 1
" let g:ale_fix_on_save = 1

" let g:ale_fixers = {
" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
" \   'python': ['black'],
" \}

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction


" Deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('smart_case', v:true)

" EasyMotion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_do_mapping = 0

" Indentline
" let g:indentLine_enabled = 1
" let g:indentLine_concealcursor = 0
" let g:indentLine_char = '┆'
" let g:indentLine_faster = 1

" NerdCommenter
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1

" Rainbow
let g:rainbow_active = 1

" UndoTree
let g:undotree_WindowLayout = 4
let g:undotree_ShortIndicators = 1
let g:undotree_RelativeTimestamp = 1
let g:undotree_SplitWidth = 20
let g:undotree_DiffpanelHeight = 9
let g:undotree_SetFocusWhenToggle = 1

set number
set textwidth=0
set wrapmargin=0

set clipboard^=unnamedplus
set laststatus=2
set t_Co=256
colorscheme flattened_dark
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " remove completion window
let mapleader =','
" Move to last known position
autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
nmap <Leader>, <Plug>(easymotion-w)
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

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

nnoremap <silent> <leader><space> :nohlsearch<CR>
vmap <silent> <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>

nnoremap <silent> <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

inoremap kj <Esc>
nnoremap ; :
nnoremap <silent> u :UndotreeToggle<CR>

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

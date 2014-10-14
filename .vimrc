"  Code for Vundle

set nocompatible
set rtp+=~/.vim/bundle/vundle.vim
call vundle#begin()
	Plugin 'gmarik/vundle.vim'
	Plugin 'scrooloose/nerdcommenter'
	Plugin 'tpope/vim-surround'
	Plugin 'scrooloose/syntastic'
    Plugin 'Lokaltog/vim-easymotion'
	Plugin 'terryma/vim-multiple-cursors'
	Plugin 'majutsushi/tagbar'
    Plugin 'sjl/gundo.vim'
    Plugin 'altercation/vim-colors-solarized'
    Plugin 'scrooloose/nerdtree'
    Plugin 'Valloric/YouCompleteMe'
call vundle#end()
filetype plugin indent on


" UI Config and Colours
    set number
    syntax enable
    set wildmenu

    python from powerline.vim import setup as powerline_setup
    python powerline_setup()
    python del powerline_setup

    set laststatus=2
    set t_Co=256

    nnoremap + <C-w>+
    nnoremap - <C-w>-
    nnoremap = <C-w>=

    set background=dark
    colorscheme solarized

" Behaviour
    set timeoutlen=200
    set autoread
    set lazyredraw
    let mapleader =',' 
    
" Space and Tabs
    set ruler
    set expandtab
    set smarttab
    set shiftwidth=4
    set tabstop=4

    set autoindent
    set smartindent

" Plugin Behaviour
    let NERDCommentWholeLinesInVMode=1

    let g:gundo_close_on_revert=1
    
    let g:solarized_termcolors=256

    let NERDTreeDirArrows=1

    let g:tagbar_autoclose=1
    let g:tagbar_autofocus=1
    let g:tagbar_sort=0

    "let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/c/.ycm_extra_conf.py'
    let g:ycm_min_num_of_chars_for_completion=2
    let g:ycm_min_num_identifier_candidate_chars=4
    let g:ycm_show_diagnostics_ui=1
    let g:ycm_warning_symbol='>'
    let g:ycm_error_symbol='>>'
    let g:ycm_complete_in_comments=0
    let g:ycm_complete_in_strings=1
    let g:ycm_collect_identifiers_from_comments_and_strings=0
    let g:ycm_collect_identifiers_from_tags_files=1
    let g:ycm_seed_identifiers_with_syntax=1
    let g:ycm_add_preview_to_completeopt=0
    let g:ycm_autoclose_preview_window_after_completion=1
    let g:ycm_autoclose_preview_window_after_insertion =0
    autocmd BufRead *.c,*.h  let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/c/.ycm_extra_conf.py'
    autocmd BufRead *.cpp    let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/cpp/.ycm_extra_conf.py'
    " Unable to seperate c and c++ header files

    "let g:neocomplete#enable_at_startup = 1
    "let g:neocmplete#enable_auto_select = 1
    "let g:neocmplete#enable_smart_case = 1
    "inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
    "inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
    
" Searching and Navigation
    set incsearch
    set hlsearch
    set smartcase

    nnoremap k j
    nnoremap j k
    vnoremap k j
    vnoremap j k

    map <Leader>w H<Leader><Leader>w
    nnoremap <silent> <leader><space> :nohlsearch<CR>

    nnoremap <silent> <F8> :TagbarToggle<CR>
    nnoremap <silent> <F4> :NERDTreeToggle<CR>

" Editing
    nnoremap <silent> <F2> :set invpaste paste?<CR>
    set pastetoggle=<F2>
    set showmode

    map :hs :sp
    inoremap kj <Esc>

    noremap <Leader>c <Leader>ci
    noremap ; :

    noremap <silent> u :GundoToggle<CR>

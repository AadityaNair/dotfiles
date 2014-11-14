"   My Ultimate .vimrc
"   Created and maintained by Aaditya M Nair
" 
"   Use or modify freely at your own risk.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"                                                        Plugin Manager

set nocompatible
set rtp+=~/.vim/bundle/vundle.vim
call vundle#begin()     " List of All Plugins

    Plugin 'gmarik/vundle.vim'              " Plugin Manager
    Plugin 'scrooloose/nerdcommenter'       " Faster Commenting  
    Plugin 'tpope/vim-surround'             " Faster working on surrounding tags (braces, HTML, etc)
    Plugin 'scrooloose/syntastic'           " Syntax Checking ( more hassle than useful)
    Plugin 'Lokaltog/vim-easymotion'        " Faster File Navigation (like really fast)
    Plugin 'terryma/vim-multiple-cursors'   " Simutaneous Multi-line Editing
    Plugin 'majutsushi/tagbar'              " View Code Structure as Tags
    Plugin 'sjl/gundo.vim'                  " Fully utilise vim's undo (graphically)

    Plugin 'dstrunk/atom-dark-vim'              " Personal Favourite 
    Plugin 'altercation/vim-colors-solarized'   " Scheme Standard for most  
    
    Plugin 'scrooloose/nerdtree'            " View Directory Structre in Vim
    Plugin 'Valloric/YouCompleteMe'         " Most awesome auto-complete there is
    Plugin 'FredKSchott/CoVim'              " Collaborative Editing

call vundle#end()
filetype plugin indent on   " Enable filetype specific plugins

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"                                                      UI Config and Colours

    set number              " Show Numbers
    syntax enable           " Syntax Highlighting
    set wildmenu            " Escape mode command autocompletion

"Configuration for powerline
    python from powerline.vim import setup as powerline_setup   
    python powerline_setup()                              
    python del powerline_setup                                  

    set laststatus=2        " Show two-line status bar
    set t_Co=256            " Make terminal to 256 colour mode

    nnoremap + <C-w>+|       " Increase split size
    nnoremap - <C-w>-|       " Decrease split size 
    nnoremap = <C-w>=|       " Equalise all splits

    set background=dark     " Colorscheme mode
    colorscheme atom_dark   " Set colourscheme
    "colorscheme solarized
    
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

    
"                                                            Behaviour
    
    set timeoutlen=200                      " Timeout for escape mode macros
    set autoread                            " Update files changed outside vim
    set lazyredraw                          " No redraw while executing macros
    let mapleader =','                      " Set default leader to a button nearby
    autocmd BufWritePost .vimrc source %    " autoupdate vimrc on change

    let CoVim_default_name = "Prometheus"   " CoVim default username
    let CoVim_default_port = "2048"         " CoVim default port

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"                                                          Space and Tabs
    
    set ruler               " Show line and column number on status bar
    set expandtab           " Expand TABs to spaces
    set smarttab            " Use TABs intelligently 
    set shiftwidth=4        " Spaces per level of indentation
    set tabstop=4           " Translate tab to 4 spaces

    set autoindent          " Indent automatically
    set smartindent         " Indent intelligently

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"                                                        AutoComplete Behaviour
    
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
    autocmd BufRead *.cpp,*.hpp    let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/cpp/.ycm_extra_conf.py'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""    

"                                                       Searching and Navigation
    
    set incsearch       " Search Patterns in real-time (as it is being typed) 
    set hlsearch        " Highlight searches
    set smartcase       " Parse cases smartly while searching

    " Invert `k` and `j` for navigation 
    nnoremap k j        
    nnoremap j k
    vnoremap k j
    vnoremap j k
   
    let NERDTreeDirArrows=1
    let g:tagbar_autoclose=1
    let g:tagbar_autofocus=1
    let g:tagbar_sort=0

    map <Leader>w <Leader><Leader>w |                   " Macro for Easy Motion
    nnoremap <silent> <leader><space> :nohlsearch<CR>|  " Clear all searches

    nnoremap <silent> <F8> :TagbarToggle<CR>|           " Tagbar Mapping
    nnoremap <silent> <F4> :NERDTreeToggle<CR>|         " Directory Tree Mapping

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"                                                             Editing
    
    nnoremap <silent> <F2> :set invpaste paste?<CR>|    " Open Paste Mode
    set pastetoggle=<F2>                                " HotKey for Paste Mode
    set showmode                                        " Display Present Mode

" Auto Paste mode (Untested)    
    let &t_SI .= "\<Esc>[?2004h"
    let &t_EI .= "\<Esc>[?2004l"
    inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
    function! XTermPasteBegin()
        set pastetoggle=<Esc>[201~
        set paste
        return ""
    endfunction

    nnoremap :hs :sp|                         " To create similar mapping for horiz or verti split (thoroughly useless)
    inoremap kj <Esc>|                        " Go to escape mode faster ( who uses `kj` in a word anyway ?) 
    nnoremap ; :|                             " Map `:` to `;` for command mode (Best Macro Ever !!!)
    nnoremap <silent> u :GundoToggle<CR>|     " Replace default undo with GUndo

"Macro to shift a line by one (up/down)
    nnoremap <C-k> :m .+1<CR>==
    nnoremap <C-j> :m .-2<CR>==
    inoremap <C-k> <Esc>:m .+1<CR>==gi
    inoremap <C-j> <Esc>:m .-2<CR>==gi
    vnoremap <C-k> :m '>+1<CR>gv=gv
    vnoremap <C-j> :m '<-2<CR>gv=gv

    let NERDCommentWholeLinesInVMode=1     " NERDCommenter Configuration
    let g:gundo_close_on_revert=1          " GUndo auto-close


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

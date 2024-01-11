-- Rewrite init.vim to init.lua. 
-- Plugin manager: lazy.vim
-- Plugins:
--  shougo/deoplete.nvim            -> hrsh7th/nvim-cmp (?X)
--  easymotion/vim-easymotion       -> ggandor/leap.nvim 
--  luochen1990/rainbow             -> https://gitlab.com/HiPhish/rainbow-delimiters.nvim
--  mbbill/undotree                 -> debugloop/telescope-undo.nvim
--  romainl/flattened               -> svrana/neosolarized.nvim (??)
--  scrooloose/nerdcommenter        -> numToStr/Comment.nvim
--  terryma/vim-multiple-cursors    -> mg979/vim-visual-multi (?X)
--  vim-airline/vim-airline         -> nvim-lualine/lualine.nvim
--  vim-airline/vim-airline-themes  -> XX

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- TODO: We shouldn't be bootstrapping plugins here.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","

-- TODO: Some plugins require additional configuration
-- TODO: Try to load a plugin along with its configuration. Maybe not possible.
require("lazy").setup({
  "ggandor/leap.nvim",
  "nvim-lualine/lualine.nvim",
  "Tsuzat/NeoSolarized.nvim",
  "numToStr/Comment.nvim",
})

vim.cmd.colorscheme("NeoSolarized")
require('lualine').setup {
  options = { theme  = "solarized_dark" },
}
require('leap').create_default_mappings()

--------------------- Other configuration

vim.opt.number = true
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.ruler = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
-- vim.opt.showmode = true
-- vim.opt.hidden = true

vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>', {silent = true}) -- TODO: Can this be replaced with a proper function

-- vim.api.nvim_create_autocmd({'BufReadPost'}, {pattern = {'*'}, command="echo 'asdf'"},)
-- TODO: Fix below command to move cursor to last position
-- vim.api.nvim_create_autocmd('BufReadPost',{ command = '<C-o>' })

-- inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
-- autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " remove completion window
-- " Move to last known position
-- autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
-- nmap <Leader>, <Plug>(easymotion-w)
-- autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

-- vmap <silent> <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>

-- nnoremap <silent> <F2> :set invpaste paste?<CR>
-- set pastetoggle=<F2>

-- nnoremap <silent> u :UndotreeToggle<CR>

-- nnoremap <silent> <C-j> :m .+1<CR>==
-- nnoremap <silent> <C-k> :m .-2<CR>==
-- inoremap <silent> <C-j> <Esc>:m .+1<CR>==gi
-- inoremap <silent> <C-k> <Esc>:m .-2<CR>==gi
-- vnoremap <silent> <C-j> :m '>+1<CR>gv=gv
-- vnoremap <silent> <C-k> :m '<-2<CR>gv=gv

-- cnoreabbrev W! w!
-- cnoreabbrev Q! q!
-- cnoreabbrev Qall! qall!
-- cnoreabbrev Wq wq
-- cnoreabbrev Wa wa
-- cnoreabbrev wQ wq
-- cnoreabbrev WQ wq
-- cnoreabbrev W w
-- cnoreabbrev Q q
-- cnoreabbrev Qall qall

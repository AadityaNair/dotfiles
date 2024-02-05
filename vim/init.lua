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
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ","

-- TODO: Some plugins require additional configuration
-- TODO: Try to load a plugin along with its configuration. Maybe not possible.
require("lazy").setup({
  "ggandor/leap.nvim",
  "nvim-lualine/lualine.nvim",
  "Tsuzat/NeoSolarized.nvim",
  "numToStr/Comment.nvim",

  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
})

vim.cmd.colorscheme("NeoSolarized")
require('lualine').setup {
  options = { theme  = "solarized_dark" },
}
require('leap').create_default_mappings()
require('Comment').setup({
    padding = true,
    sticky = true,
    toggler = {
        line = '<leader>ci'
    },
    opleader = {
        line = '<leader>ci'
    },
    mappings = {
        basic = true,
        extra = false,
    },
})

local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {{ name = 'buffer' },}
    )
})

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
})

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
})


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


vim.keymap.set('n','<C-j>',':m .+1<CR>==',{silent = true})
vim.keymap.set('n','<C-k>',':m .-2<CR>==',{silent = true})
vim.keymap.set('i','<C-j>','<Esc>:m .+1<CR>==gi',{silent = true})
vim.keymap.set('i','<C-k>','<Esc>:m .-2<CR>==gi',{silent = true})
vim.keymap.set('v','<C-j>',":m '>+1<CR>gv=gv",{silent = true})
vim.keymap.set('v','<C-k>',":m '<-2<CR>gv=gv",{silent = true})

-- TODO: Replace this with a proper function
vim.cmd('cnoreabbrev W! w!')
vim.cmd('cnoreabbrev Q! q!')
vim.cmd('cnoreabbrev Qall! qall!')
vim.cmd('cnoreabbrev Wq wq')
vim.cmd('cnoreabbrev Wa wa')
vim.cmd('cnoreabbrev wQ wq')
vim.cmd('cnoreabbrev WQ wq')
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Qall qall')


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


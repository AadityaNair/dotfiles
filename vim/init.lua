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
-- TODO: vista.vim, trouble.nvim
-- TODO: Full Refactor: Looks, autocomplete, Work file, 
require("lazy").setup({
    "nvim-lualine/lualine.nvim",
    {"Tsuzat/NeoSolarized.nvim", lazy=true,},
    "numToStr/Comment.nvim",

    'nvim-treesitter/nvim-treesitter',
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},
        -- TODO: Maybe there is some interesting options here. But for now only this is fine.
        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        },
    },
    
    {'folke/twilight.nvim'},
    {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
})

-- TODO: Only generate indentlines when there are more than two lines indented.
require('ibl').setup({
    indent = {char='│'},
})
vim.cmd.colorscheme("NeoSolarized")
require('lualine').setup {
  options = { theme  = "solarized_dark" },
}
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
vim.opt.termguicolors = true
require("bufferline").setup({
    options = {always_show_bufferline = false,},
})

-- TODO: Configure noice and notify

require("notify").setup({
    background_colour = "#000000",
    top_down = true,
    render = 'minimal',
    stages = 'fade',
})
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})


-- TODO: nvim-treesitter/nvim-treesitter-textobjects
-- TODO: nvim-treesitter/nvim-treesitter-context
require("nvim-treesitter.install").prefer_git = true
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'graphql',
        'hack',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'php',
        'python',
        'regex',
        'ruby',
        'rust',
        'starlark',
        'thrift',
        'toml',
        'vim',
        'vimdoc',
        'yaml',
    },
    highlight = {
        enable = true,
        -- disable = {'latex'},
    },
    indent = {
        enable = true,
        -- disable = {'latex'},
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

-- TODO: Wrap this in a vim.cmd()
-- autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

-- inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
-- autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " remove completion window
-- " Move to last known position
-- nmap <Leader>, <Plug>(easymotion-w)
-- autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

-- vmap <silent> <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>

-- nnoremap <silent> <F2> :set invpaste paste?<CR>
-- set pastetoggle=<F2>

-- nnoremap <silent> u :UndotreeToggle<CR>


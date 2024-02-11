--  luochen1990/rainbow             -> https://gitlab.com/HiPhish/rainbow-delimiters.nvim
--  mbbill/undotree                 -> debugloop/telescope-undo.nvim
--  terryma/vim-multiple-cursors    -> mg979/vim-visual-multi (?X)

vim.g.python3_host_prog="/usr/bin/python3"
vim.g.loaded_node_provider=0 
vim.g.loaded_perl_provider=0
vim.g.loaded_python_provider=0
vim.g.mapleader = ","

------------------------------------------------- Plugins Setup --------------------------------------------------

-- TODO: vista.vim, trouble.nvim
-- TODO: Full Refactor: Looks, autocomplete, Work file, 
-- TODO: Bring the default keymapings to the top so that those work even if some plugins break things.
-- TODO: When there is an error, the error window goes away too fast to actually read the thing.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    "nvim-lualine/lualine.nvim",
    {"folke/tokyonight.nvim", lazy=false, priority=1000,},
    "numToStr/Comment.nvim",

    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-context',
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
    
    {'folke/twilight.nvim'}, -- TODO: Fix this theme or get a whole new theme.
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

----------------------------------------------------- UI Improvements ----------------------------------------------


require("tokyonight").setup({
    terminal_colors = true,
    styles = {
    -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
  },
})


vim.opt.termguicolors = true
vim.cmd.colorscheme("tokyonight-night")
require('lualine').setup {
  options = { theme  = "tokyonight" },
}
require("bufferline").setup({
    options = {always_show_bufferline = false,},
})
-- TODO: Maybe it is better if the notifications are on the bottom right
--       And without a box like in fidget.nvim. Investigate
-- TODO: Have a way to hold the notification for some time.
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


------------------------------------------------ Coding Quality of Life ------------------------------------------

-- TODO: Only generate indentlines when there are more than two lines indented.
-- TODO: Rainbow indentlines
require('ibl').setup({
    indent = {char='│'},
})
-- TODO: This can use a good looking at.
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

-- TODO: nvim-treesitter/nvim-treesitter-textobjects
require("nvim-treesitter.install").prefer_git = true
-- TODO: Finetune the values below.
require("treesitter-context").setup({
    enable=true,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
})
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
        -- disable = {'bash'},
    },
    indent = {
        enable = true,
        -- disable = {'latex'},
    },
})

-- Set strings to be italics
hl_settings = vim.api.nvim_get_hl(0, {name="String"})
hl_settings['italic']=true
vim.api.nvim_set_hl(0, "String", hl_settings)

------------------------------------------------------ Auto Complete -------------------------------
local cmp = require'cmp'
-- TODO: Use TAB to iterate through options.
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
        ['<Tab>'] = cmp.mapping.select_next_item({ behaviour = "select"}),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behaviour = "select" }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Esc>'] = cmp.mapping.close(),
    }),
    -- TODO: These group indices are weird. We probably don't need it. 
    --       I think the order defines the index.
    sources = cmp.config.sources({
        { name = 'nvim_lsp', group_index = 1 },
        { name = 'buffer',   group_index = 2 },
        { name = 'path',     group_index = 3 },
        { name = 'luasnip',  group_index = 4,},
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

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['bash-language-server'].setup {
    capabilities = capabilities
  }


----------------------------------------------------  Other configuration   ------------------------------------------

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
vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>', {silent = true})

vim.keymap.set('n', '<Leader>r', '<Cmd>edit!<CR>')

vim.keymap.set('n','<C-j>',':m .+1<CR>==',{silent = true})
vim.keymap.set('n','<C-k>',':m .-2<CR>==',{silent = true})
vim.keymap.set('i','<C-j>','<Esc>:m .+1<CR>==gi',{silent = true})
vim.keymap.set('i','<C-k>','<Esc>:m .-2<CR>==gi',{silent = true})
vim.keymap.set('v','<C-j>',":m '>+1<CR>gv=gv",{silent = true})
vim.keymap.set('v','<C-k>',":m '<-2<CR>gv=gv",{silent = true})

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

-- Copied from https://github.com/creativenull/dotfiles/blob/9ae60de4f926436d5682406a5b801a3768bbc765/config/nvim/init.lua#L70-L86
-- Return to the previous cursor position.
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

-- Set the right filetypes.
vim.filetype.add({
 filename = {
   ['TARGETS'] = 'starlark',
 },
})

-- inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
-- autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif " remove completion window
-- autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

-- vmap <silent> <C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>

-- nnoremap <silent> <F2> :set invpaste paste?<CR>
-- set pastetoggle=<F2>

-- nnoremap <silent> u :UndotreeToggle<CR>


--  luochen1990/rainbow             -> https://gitlab.com/HiPhish/rainbow-delimiters.nvim
--  mbbill/undotree                 -> debugloop/telescope-undo.nvim
--  terryma/vim-multiple-cursors    -> mg979/vim-visual-multi (?X)


----------------------------------------------------  Other configuration   ------------------------------------------

vim.g.python3_host_prog="/usr/bin/python3"
vim.g.loaded_node_provider=0 
vim.g.loaded_perl_provider=0
vim.g.loaded_python_provider=0

vim.g.mapleader = ","
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

------------------------------------------------- Plugins Setup --------------------------------------------------

-- TODO: vista.vim
-- TODO: When there is an error, the error window goes away too fast to actually read the thing.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

company = require("company_specific_config")

plugins = {
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
    -- TODO: Configure todo-comments and trouble.nvim 
    {'folke/todo-comments.nvim', dependencies = "nvim-lua/plenary.nvim" },
    {"folke/trouble.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
    {'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
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
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'debugloop/telescope-undo.nvim',
            -- NOTE: Adding anything in depedencies except plenary.nvim is wrong. 
            --       Technically, file-browser.nvim depends on plenary.nvim and telescope.nvim
            --       But, because all `depedencies` really mean is that it downloads the dependency
            --       before the main one, we can put anything in here. Only thing is, if we decide to
            --       remove telescope.nvim, the depedencies are deleted too. Which is OK for this case.
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
                vim.o.timeout = true
                vim.o.timeoutlen = 300
               end,
        opts = {
            -- TODO: your configuration comes here
        }
    }

}

-- List all the plugins from the company specific code and add it to default list.
-- Only when company.plugin is set.
if company.plugin then
    len = require("table").getn(plugins)

    for index, entry in pairs(company.plugin) do
        plugins[len+index] = entry
    end
        
end

require('lazy').setup(plugins)
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

-- TODO: Few more possibilities here. We don't need to to look too much different than comments.
require("todo-comments").setup({
    signs = false,
})

local telescope = require('telescope')

telescope.setup({
    pickers = {
        find_files = {
            hidden = false,
        },
    },
    extensions = {
        file_browser = {
            hijack_netrw = true,
            grouped = false,
            collapsed_dir = true,
            previewer = company.use_previewer_for_files,

            -- display_stat = true,
        },
    },
})
telescope.load_extension "file_browser"
telescope.load_extension "undo"

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', telescope.extensions.file_browser.file_browser)
vim.keymap.set('n', '<leader>tt', ":Telescope")
vim.keymap.set('n', 'u', telescope.extensions.undo.undo)
-- TODO: Just `T/t` is also some function. Change it.

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

require('trouble').setup({})

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
        ['<Tab>'] = cmp.mapping.select_next_item({ behaviour = "select"}),
        ['<S-Tab>'] = cmp.mapping.select_prev_item({ behaviour = "select" }),
        ['<Esc>'] = function(fallback)
                        cmp.mapping.close()
                        vim.cmd('stopinsert') 
                    end,
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
-- TODO: Consider if `bashls` is useful for zsh since syntax may be slightly different.
require('lspconfig')['bashls'].setup {
    capabilities = capabilities,
    filetypes= {'sh', 'zsh'},
  }

-- Set the right filetypes for zsh
vim.filetype.add({
    extension = {
        ['zsh'] = 'sh',
    },
    filename = {
        ['zshrc'] = 'sh',
    },
})

company.setup()

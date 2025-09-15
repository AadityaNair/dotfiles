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
-- add function to get length of line
vim.opt.clipboard = 'unnamedplus'  -- Integrate vim with system clipboard.

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

function TableConcat(t1, t2)
    for _, v in ipairs(t2) do
        require("table").insert(t1, v)
    end
    return t1
end

------------------------------------------------- Plugins Setup --------------------------------------------------

-- TODO: vista.vim
-- TODO: When there is an error, the error window goes away too fast to actually read the thing.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- TODO: Avoid needing to updated the in-repo config file.
--       I want to avoid leaving a dirty repo.
company = require("company_specific_config")
ui = require("ui")
ux = require("ux")

plugins = {
    "numToStr/Comment.nvim",
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-context',
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        config = function(_, opts)
            local lspconfig = require('lspconfig')
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            -- TODO: Not have per-server level capabilities
            lspconfig['lua_ls'].setup({capabilities = capabilities})
        end
    },
    {
        "saghen/blink.cmp",
        dependencies = {},
        version = "*",
        opts = {
            -- TODO: Tab to iterate through options
            keymap = {preset = "default"},
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        -- TODO: Move this to a different keymap call elsewhere,
        -- TODO: Look into more configuration
        keys = {{"s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash"},},
    },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
    {
        -- TODO: Find an alternative undotree impl and remove telescope entirely
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim',
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {"kevinhwang91/promise-async"},
    },

}

-- List all the plugins from the company specific code and add it to default list.
-- Only when company.plugin is set.
plugins = TableConcat(plugins, ui.plugins)
plugins = TableConcat(plugins, ux.plugins)
plugins = TableConcat(plugins, company.plugins)
require('lazy').setup(plugins)

ui.setup()
ux.setup()
------------------------------------------------ Quality of Life ------------------------------------------

vim.o.foldcolumn = 'auto:9' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- TODO: Look into collapsing CPP namespaces automatically. And not having indents for it as well.
-- TODO: Add command to just fold the current fold
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

-- TODO: Only generate indentlines when there are more than two lines indented.
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

-- Custom commentstrings
local ft = require('Comment.ft')
ft.set('kdl', '//%s')

local telescope = require('telescope')

telescope.setup({
    extensions = {
        undo = {
            mappings = {
                i = {["<CR>"] = require("telescope-undo.actions").restore},
                n = {["<CR>"] = require("telescope-undo.actions").restore},
            },
            -- layout_strategy = "vertical",
            side_by_side=true,
        },
    },
})
telescope.load_extension "undo"
vim.keymap.set('n', 'u', telescope.extensions.undo.undo, {silent=true})

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
        'erlang',
        'fish',
        'go',
        'graphql',
        'hack',
        'javascript',
        'json',
        'kdl',
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

-- Set the right filetypes for zsh
vim.filetype.add({
    extension = {
        ['zsh'] = 'sh',
    },
    filename = {
        ['zshrc'] = 'sh',
    },
})

vim.api.nvim_create_user_command("DiagnosticToggle", function()
    local config = vim.diagnostic.config
    local vt = config().virtual_text
	config {
		virtual_text = not vt,
		underline = not vt,
		signs = not vt,
	}
end, {desc = "Toggle showing LSPErrors/Hints/etc"}
)
company.setup()

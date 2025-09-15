module = {}
module.plugins = {
    "numToStr/Comment.nvim",
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-context',
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        -- TODO: Move this to a different keymap call elsewhere,
        -- TODO: Look into more configuration
        keys = {{"s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash"},},
    },
    {'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
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

function module.setup()
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
end

return module



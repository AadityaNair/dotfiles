module = {}
local TableConcat = require("common").TableConcat

local supported_langs = {
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
}

local default_lsps = {
    'lua_ls',
    'bashls',
}
local company_lsps = require("company").custom_lsps

module.plugins = {
    {'nvim-treesitter/nvim-treesitter', branch = "main", build = ":TSUpdate"},
    'nvim-treesitter/nvim-treesitter-context',
    {
        "saghen/blink.cmp",
        dependencies = {},
        version = "*",
        opts = {
            -- TODO: Tab to insert the first time always and the iterate through options
            keymap = {
                preset = "none",
                ['<Up>'] = {'select_prev', 'fallback'},
                ['<Down>'] ={'select_next', 'fallback'},
                ['<Tab>'] ={
                    function(cmp)
                        if cmp.snippet_active() then return cmp.accept()
                        else return cmp.select_and_accept() end
                    end,
                    'select_next',
                    'fallback'
                },
                ['<S-Tab>'] ={'select_prev', 'fallback'},
                ['<Esc>'] ={'hide', 'fallback'},

            },
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = {
                documentation = { auto_show = false },
                ghost_text = { enabled = true},
                list = {selection = {preselect = true, auto_insert = true} },
                menu = {
                    draw = {
                        columns = {
                            {'kind_icon'},
                            {'label', 'label_description', gap=1},
                            {'source_name'},
                        },
                        treesitter = { 'lsp' },
                    }
                },
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust" },
            signature = { enabled = true },
        },
        opts_extend = { "sources.default" },
    },
}

function module.setup()
    -- TODO: Finetune the values below.
    require("treesitter-context").setup({
        enable=true,
        max_lines = 0,
        min_window_height = 0,
        line_numbers = true,
    })

    require("nvim-treesitter").install(supported_langs)
    vim.api.nvim_create_autocmd('FileType',{
        pattern = supported_langs,
        callback = function()
            vim.treesitter.start()
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            -- FIX: treesitter indent doesn't actually work. Figure out why.
            -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

            -- Set strings to be italics
            local hl_settings = vim.api.nvim_get_hl(0, {name="String"})
            hl_settings['italic']=true
            vim.api.nvim_set_hl(0, "String", hl_settings)
        end
    })

    vim.filetype.add({
        extension = {
            ['zsh'] = 'bash',
            ['sh'] = 'bash',
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
    for _, lsp in ipairs(TableConcat(default_lsps, company_lsps)) do
        vim.lsp.enable(lsp)
    end
end

return module

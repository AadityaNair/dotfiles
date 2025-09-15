module = {}

local default_lsp = {
    'lua_ls'
}
local custom_lsps = require("company_specific_config").custom_lsps

function TableConcat(t1, t2)
    for _, v in ipairs(t2) do
        require("table").insert(t1, v)
    end
    return t1
end

local enabled_lsps = TableConcat(default_lsp, custom_lsps)

module.plugins = {
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        config = function()
            local lspconfig = require('lspconfig')
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            for _, lsp in ipairs(enabled_lsps) do
                lspconfig[lsp].setup({capabilities = capabilities})
            end
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
}

function module.setup()
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
end

return module



module = {}
module.plugins = {
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



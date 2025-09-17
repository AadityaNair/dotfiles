module = {}

-- TODO: support providing configs as well.
local default_lsp = {
    'lua_ls',
    'bashls',
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
                list = {selection = {preselect = true, auto_insert = true} }
            },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust" }
        },
        opts_extend = { "sources.default" },
    },
}

-- Copied directly from https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
local function lua_lsp_for_neovim() -- TODO: Fix the `vim` variable not being recognized. Or make folke/lazydev work.
    vim.lsp.config('lua_ls', {
        on_init = function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = {
                    version = 'LuaJIT',
                    path = {
                        'lua/?.lua',
                        'lua/?/init.lua',
                    },
                },
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME
                    }
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {
                        'vim',
                        'require'
                    },
                },
            })
      end,
      settings = {Lua = {}}
    })
end

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
    lua_lsp_for_neovim()
end

return module

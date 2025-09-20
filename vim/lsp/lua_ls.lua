-- We only use lua_ls for neovim config (for now, atleast)
-- So this config is built based on that.
-- Graciously copied from:
--   https://github.com/neovim/nvim-lspconfig/blob/master/lsp/lua_ls.lua
--   https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls

---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        'selene.toml',
        'selene.yml',
        '.git',
    },
    -- Below is the only Neovim specific configuration. Above is the default config
    settings = {
        Lua = {
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
                    vim.env.VIMRUNTIME,
                    '${3rd}/luv/library',
                    '${3rd}/busted/library',
                }
            },
            -- Get the language server to recognize the `vim` global variable
            diagnostics = {globals = {'vim'}},
        }
    }
}

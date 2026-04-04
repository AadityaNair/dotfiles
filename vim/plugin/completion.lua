local gh_url = require("common").gh_url
vim.pack.add({
    gh_url("xzbdmw/colorful-menu.nvim"), -- TODO: Blink does the job apparently.
    { src = gh_url("saghen/blink.cmp"), version = vim.version.range("*") },
})

require("blink.cmp").setup(
    {
        -- TODO: Tab to insert the first time always and the iterate through options
        -- TODO: Fully investigate config
        keymap = {
            preset = "none",
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<Tab>"] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.accept()
                    else
                        return cmp.select_and_accept()
                    end
                end,
                "select_next",
                "fallback",
            },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<Esc>"] = { "hide", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = { auto_show = false },
            ghost_text = { enabled = true, show_with_menu = false },
            list = { selection = { preselect = true, auto_insert = true } },
            keyword = { range = "full" },
            menu = {
                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                        { "source_name" },
                    },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                    },

                    treesitter = { "lsp" },
                },
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust" },
        signature = { enabled = true },
    }
    -- TODO: Figure out what this opts_extend does.
    -- opts_extend = { "sources.default" },
)

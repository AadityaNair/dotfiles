-- Flexoki Dark -- neovim colorscheme.
-- Loaded by vim/plugin/appearance.lua through vim/theme.lua.

return {
    plugin = "AadityaNair/flexoki-neovim",
    colorscheme = "flexoki-dark",
    lualine = "flexoki-dark",
    setup = function()
        require("flexoki").setup({
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
            },
        })
    end,
}

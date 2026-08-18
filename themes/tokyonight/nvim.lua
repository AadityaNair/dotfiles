-- TokyoNight Night -- neovim colorscheme.
-- Loaded by vim/plugin/appearance.lua through vim/theme.lua.

return {
    plugin = "folke/tokyonight.nvim",
    colorscheme = "tokyonight-night",
    lualine = "tokyonight",
    setup = function()
        require("tokyonight").setup({
            terminal_colors = true,
            styles = {
                comments = { italic = true },
                keywords = { italic = true },
            },
        })
    end,
}

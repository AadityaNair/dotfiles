vim.opt.termguicolors = true

local gh_url = require("common").gh_url

-- Colorscheme: Loaded at startup.
-- theme.lua is a symlink into themes/. See themes/README.md to switch.
-- Only the active colorscheme plugin is registered, so the other one costs
-- nothing here. A missing or dangling link leaves neovim on its default colours.
local theme_file = vim.fn.stdpath("config") .. "/theme.lua"
local theme = vim.uv.fs_stat(theme_file) and dofile(theme_file)

if theme then
    vim.pack.add({ gh_url(theme.plugin) })
    theme.setup()
    vim.cmd.colorscheme(theme.colorscheme)
end

-- Lazy UI setup
local function setup_ui()
    vim.pack.add({
        gh_url("folke/todo-comments.nvim"), -- TODO: Replace with simple code.
        gh_url("nvim-lualine/lualine.nvim"), -- TODO: Replace with custom statusline
        gh_url("akinsho/bufferline.nvim"),
        gh_url("nvim-tree/nvim-web-devicons"),
    })

    require("lualine").setup({
        options = {
            theme = theme and theme.lualine or "auto",
            icons_enabled = true,
            globalstatus = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "searchcount", "selectioncount", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    })

    require("bufferline").setup({
        options = { always_show_bufferline = false },
    })

    vim.opt.cmdheight = 0

    require("todo-comments").setup({
        signs = false,
        highlight = { multiline = false },
    })
end

-- Defer loading UI plugins until after the interface has drawn
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        vim.schedule(setup_ui)
    end,
    once = true,
})

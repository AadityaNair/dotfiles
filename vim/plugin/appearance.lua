local gh_url = require("common").gh_url

-- Colorscheme: Loaded at startup
vim.pack.add({
    gh_url("folke/tokyonight.nvim"),
})

require("tokyonight").setup({
    terminal_colors = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
    },
})

vim.opt.termguicolors = true
vim.cmd.colorscheme("tokyonight-night")

-- Lazy UI setup
local function setup_ui()
    vim.pack.add({
        gh_url("folke/todo-comments.nvim"), -- TODO: Replace with simple code.
        gh_url("nvim-lualine/lualine.nvim"), -- TODO: Replace with custom statusline
        gh_url("akinsho/bufferline.nvim"),
        gh_url("nvim-tree/nvim-web-devicons"),
        gh_url("folke/noice.nvim"),
        gh_url("MunifTanjim/nui.nvim"),
        gh_url("rcarriga/nvim-notify"),
    })

    require("lualine").setup({
        options = {
            theme = "tokyonight",
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

    require("notify").setup({
        background_colour = "#000000",
        top_down = true,
        render = "minimal",
        stages = "fade",
    })

    require("noice").setup({
        views = {
            cmdline_popup = {
                position = { row = "50%", col = "50%" },
            },
        },
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true,
            },
        },
        presets = {
            bottom_search = true,
            command_palette = true,
            long_message_to_split = true,
            inc_rename = false,
            lsp_doc_border = false,
        },
    })

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

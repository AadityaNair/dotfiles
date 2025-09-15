module = {}
module.plugins = {
    "nvim-lualine/lualine.nvim",
    { "catppuccin/nvim", lazy = false, priority = 1000 },
    { "folke/todo-comments.nvim", dependencies = "nvim-lua/plenary.nvim" },
    { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {}, -- Apparently this line is important
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
}

function module.setup()
    require("catppuccin").setup({
        term_colors = true,
        styles = {
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { "italic" },
            keywords = { "italic" },
        },
        integrations = {
            blink_cmp = { style = "bordered" },
            cmp = true,
            flash = true,
            gitsigns = true,
            indent_blankline = {
                enabled = true,
                scope_color = "", -- catppuccin color (eg. `lavender`) Default: text
                colored_indent_levels = false,
            },
            noice = true,
            notify = true,
            nvimtree = true,
            semantic_tokens = true,
            treesitter = true,
            treesitter_context = true,
            ufo = true,
            telescope = {
                enabled = true,
            },
        },
    })

    vim.opt.termguicolors = true
    vim.cmd.colorscheme("catppuccin-mocha")
    require("lualine").setup({
        options = {
            theme = "catppuccin-mocha",
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
        extensions = { "lazy" },
    })
    -- TODO: Add catppuccin theme
    require("bufferline").setup({
        options = { always_show_bufferline = false },
    })
    -- NOTE: Use :NoiceHistory to get notification history.
    require("notify").setup({
        background_colour = "#000000",
        top_down = true,
        render = "minimal",
        stages = "fade",
    })
    require("noice").setup({
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                ["vim.lsp.util.stylize_markdown"] = true,
                ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
            },
        },
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
        },
    })

    require("todo-comments").setup({
        signs = false,
        highlight = { multiline = false },
    })
end

return module

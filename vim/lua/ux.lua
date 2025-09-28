module = {}
module.plugins = {
    "numToStr/Comment.nvim",
    { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
    {
        -- TODO: Find an alternative undotree impl and remove telescope entirely
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "debugloop/telescope-undo.nvim",
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
    },
}

function module.setup()
    vim.o.foldcolumn = "auto:9" -- '0' is not bad
    vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

    -- TODO: Look into collapsing CPP namespaces automatically. And not having indents for it as well.
    -- TODO: Add command to just fold the current fold
    -- TODO: All fold symbols should take the same line
    -- TODO: Maybe it would be useful to do this in the LSP config
    require("ufo").setup({
        provider_selector = function()
            return { "treesitter", "indent" }
        end,
    })

    -- TODO: Only generate indentlines when there are more than two lines indented.
    require("ibl").setup({
        indent = { char = "│" },
    })
    require("Comment").setup({
        padding = true,
        sticky = true,
        toggler = {
            line = "<leader>ci",
        },
        opleader = {
            line = "<leader>ci",
        },
        mappings = {
            basic = true,
            extra = false,
        },
    })

    -- Custom commentstrings
    local ft = require("Comment.ft")
    ft.set("kdl", "//%s")

    local telescope = require("telescope")

    telescope.setup({
        extensions = {
            undo = {
                mappings = {
                    i = { ["<CR>"] = require("telescope-undo.actions").restore },
                    n = { ["<CR>"] = require("telescope-undo.actions").restore },
                },
                -- layout_strategy = "vertical",
                side_by_side = true,
            },
        },
    })
    telescope.load_extension("undo")
    vim.keymap.set("n", "u", telescope.extensions.undo.undo, { silent = true })
end

return module

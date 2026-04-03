plugins = {
    "numToStr/Comment.nvim",
    "mbbill/undotree",
    { "akinsho/bufferline.nvim", dependencies = "nvim-tree/nvim-web-devicons" },
    { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
    },
}

gh_url = require("common").gh_url

vim.pack.add({
    gh_url("numToStr/Comment.nvim"),
    gh_url("mbbill/undotree"),
    gh_url("akinsho/bufferline.nvim"),
    gh_url("nvim-tree/nvim-web-devicons"), -- dep to above
    gh_url("lukas-reineke/indent-blankline.nvim"),
    gh_url("kevinhwang91/nvim-ufo"),
    gh_url("kevinhwang91/promise-async"), -- dep to above
})

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
-- TODO: Reenable this
-- require("ibl").setup({
--     indent = { char = "│" },
-- })
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

vim.keymap.set("n", "u", vim.cmd.UndotreeToggle)
-- undodir/undolevels and set undofile are options if we are fine with double writes

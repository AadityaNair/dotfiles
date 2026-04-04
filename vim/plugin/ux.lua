local gh_url = require("common").gh_url

vim.pack.add({
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
require("ibl").setup({
    indent = { char = "│" },
})

-- Native Commenting
vim.keymap.set("n", "<leader>ci", "gcc", { remap = true, desc = "Toggle line comment" })
vim.keymap.set("x", "<leader>ci", "gc", { remap = true, desc = "Toggle selection comment" })

-- Custom commentstrings
vim.api.nvim_create_autocmd("FileType", {
    pattern = "kdl",
    callback = function()
        vim.bo.commentstring = "// %s"
    end,
})

vim.keymap.set("n", "u", function()
    vim.cmd.packadd("nvim.undotree")
    vim.cmd.Undotree()
end)
-- undodir/undolevels and set undofile are options if we are fine with double writes

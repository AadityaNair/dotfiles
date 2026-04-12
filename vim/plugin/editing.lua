local gh_url = require("common").gh_url
vim.pack.add({
    gh_url("lukas-reineke/indent-blankline.nvim"),
})

local hooks = require("ibl.hooks")
require("ibl").setup({
    indent = { char = "│" },
})
hooks.register(hooks.type.VIRTUAL_TEXT, function(_, _, _, virt_text)
    for i = 1, math.min(2, #virt_text) do
        virt_text[i] = { " ", { "NonText" } }
    end
    return virt_text
end)

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

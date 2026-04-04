local supported_langs = {
    "bash",
    "c",
    "cpp",
    "diff",
    "erlang",
    "fish",
    "go",
    "graphql",
    "hack",
    "javascript",
    "json",
    "kdl",
    "lua",
    "markdown",
    "markdown_inline",
    "php",
    "python",
    "regex",
    "ruby",
    "rust",
    "starlark",
    "thrift",
    "toml",
    "vim",
    "vimdoc",
    "yaml",
}

local gh_url = require("common").gh_url
vim.pack.add({
    gh_url("nvim-treesitter/nvim-treesitter"),
    gh_url("nvim-treesitter/nvim-treesitter-context"),
})

require("treesitter-context").setup({
    enable = true,
    max_lines = 2, -- Only show context upto two levels.
    min_window_height = 0,
    line_numbers = true,
})

require("nvim-treesitter").install(supported_langs)
vim.api.nvim_create_autocmd("FileType", {
    pattern = supported_langs,
    callback = function()
        vim.treesitter.start()
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        -- FIX: treesitter indent doesn't actually work. Figure out why.
        -- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

        -- Set strings to be italics (update = true is a nvim 0.12 feature)
        vim.api.nvim_set_hl(0, "String", { italic = true, update = true })
    end,
})

vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == "nvim-treesitter" and kind == "update" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")
        end
    end,
})

vim.filetype.add({
    extension = {
        ["zsh"] = "bash",
        ["sh"] = "bash",
    },
})

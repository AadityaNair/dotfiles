-- TODO: Set keybindings for incremental selection.
-- Current Keybindings (Visual Mode only):
-- an -> Select [nth] child node
-- in -> Select [nth] parent node
-- ]n -> Select [nth] next node
-- [n -> Select [nth] prev node
-- You need to see it to understand
-- Also, https://github.com/nvim-treesitter/nvim-treesitter-textobjects

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
    "latex",
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

-- Returned so the ansible provisioning task can dofile() this same file
-- headlessly and block on the exact install it kicks off here, instead of
-- guessing how long installation takes or duplicating this language list.
--
-- max_jobs caps concurrent compiles: install()'s default (100, effectively
-- unbounded) spawns a C/C++ compiler per language at once. On a fresh host
-- installing all ~28 parsers, that's 28 concurrent compiles - enough to OOM
-- and knock the box off SSH mid-provisioning. One job per core avoids
-- oversubscribing the machine, and naturally scales down on the small,
-- low-core hosts that are also the ones tightest on memory.
local install_task = require("nvim-treesitter").install(supported_langs, { max_jobs = vim.uv.available_parallelism() })

vim.api.nvim_create_autocmd("FileType", {
    pattern = supported_langs,
    callback = function()
        vim.treesitter.start()
        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

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

return install_task

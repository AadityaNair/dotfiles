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

local default_lsps = {
    "lua_ls", -- Only for neovim configs
    "bashls", -- Bash scripts
    "pyright", -- Python
    "rust_analyzer", -- Rust
    "zls", -- Zig
}

local gh_url = require("common").gh_url
vim.pack.add({
    gh_url("nvim-treesitter/nvim-treesitter"),
    gh_url("stevearc/conform.nvim"), -- TODO: Only on BufWritePre. Whole thing under eval.
    gh_url("nvim-treesitter/nvim-treesitter-context"),
    gh_url("xzbdmw/colorful-menu.nvim"), -- TODO: Plugin under eval
    { src = gh_url("saghen/blink.cmp"), version = vim.version.range("*") },
})

require("blink.cmp").setup(
    {
        -- TODO: Tab to insert the first time always and the iterate through options
        -- TODO: Fully investigate config
        keymap = {
            preset = "none",
            ["<Up>"] = { "select_prev", "fallback" },
            ["<Down>"] = { "select_next", "fallback" },
            ["<Tab>"] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.accept()
                    else
                        return cmp.select_and_accept()
                    end
                end,
                "select_next",
                "fallback",
            },
            ["<S-Tab>"] = { "select_prev", "fallback" },
            ["<Esc>"] = { "hide", "fallback" },
        },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = { auto_show = false },
            ghost_text = { enabled = true, show_with_menu = false },
            list = { selection = { preselect = true, auto_insert = true } },
            keyword = { range = "full" },
            menu = {
                draw = {
                    columns = {
                        { "kind_icon" },
                        { "label", "label_description", gap = 1 },
                        { "source_name" },
                    },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                    },

                    treesitter = { "lsp" },
                },
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = { implementation = "prefer_rust" },
        signature = { enabled = true },
    }
    -- TODO: Figure out what this opts_extend does.
    -- opts_extend = { "sources.default" },
)

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

        -- Set strings to be italics
        local hl_settings = vim.api.nvim_get_hl(0, { name = "String" })
        hl_settings["italic"] = true
        vim.api.nvim_set_hl(0, "String", hl_settings)
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

vim.api.nvim_create_user_command("DiagnosticToggle", function()
    local config = vim.diagnostic.config
    local vt = config().virtual_text
    config({
        virtual_text = not vt,
        underline = not vt,
        signs = not vt,
    })
end, { desc = "Toggle showing LSPErrors/Hints/etc" })

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { desc = "Format the whole file or selected section", range = true })

for _, lsp in ipairs(default_lsps) do
    vim.lsp.enable(lsp)
end

require("conform").setup({
    formatters_by_ft = {
        python = { "ruff" },
        lua = { "stylua" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
require("conform").formatters.ruff = {
    command = "uv",
    args = {
        "run",
        "ruff",
        "format",
        "--force-exclude",
        "--stdin-filename",
        "$FILENAME",
        "-",
    },
    range_args = function(_, ctx)
        return {
            "run",
            "ruff",
            "format",
            "--force-exclude",
            "--range",
            string.format(
                "%d:%d-%d:%d",
                ctx.range.start[1],
                ctx.range.start[2] + 1,
                ctx.range["end"][1],
                ctx.range["end"][2] + 1
            ),
            "--stdin-filename",
            "$FILENAME",
            "-",
        }
    end,
}

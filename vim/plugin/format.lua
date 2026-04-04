local gh_url = require("common").gh_url

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    if not vim.g.conform_setup then
        setup_conform()
    end
    require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { desc = "Format the whole file or selected section", range = true })

-- Lazy-init conform
function setup_conform()
    if vim.g.conform_setup then
        return
    end
    vim.pack.add({ gh_url("stevearc/conform.nvim") })
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
    vim.g.conform_setup = true
end

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.py", "*.lua" },
    callback = function()
        setup_conform()
    end,
})

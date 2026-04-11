local default_lsps = {
    "lua_ls", -- Only for neovim configs
    "bashls", -- Bash scripts
    "pyright", -- Python
    "rust_analyzer", -- Rust
    "zls", -- Zig
    "jsonls", -- JSON
}

for _, lsp in ipairs(default_lsps) do
    vim.lsp.enable(lsp)
end

-- TODO: rachartier/tiny-inline-diagnostic.nvim for nice looking diagnostics.
vim.api.nvim_create_user_command("DiagnosticToggle", function()
    local config = vim.diagnostic.config
    local vt = config().virtual_text
    config({
        virtual_text = not vt,
        underline = not vt,
        signs = not vt,
    })
end, { desc = "Toggle showing LSPErrors/Hints/etc" })

-- Show LSP progress in terminal title/tab bar via OSC 9;4 escape sequence.
-- Supported by Ghostty, WezTerm, Windows Terminal, etc.
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local value = ev.data.params.value or {}
        if not value.kind then
            return
        end

        local status = value.kind == "end" and 0 or 1
        local percent = value.percentage or 0

        local osc_seq = string.format("\27]9;4;%d;%d\a", status, percent)

        if os.getenv("TMUX") then
            osc_seq = string.format("\27Ptmux;\27%s\27\\", osc_seq)
        end

        io.stdout:write(osc_seq)
        io.stdout:flush()
    end,
})

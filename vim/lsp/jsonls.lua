---@brief
---
--- https://github.com/microsoft/vscode-json-languageservice
---
--- JSON language server extracted from VSCode.
--- `vscode-json-language-server` can be installed via `npm`:
--- ```sh
--- npm i -g vscode-langservers-extracted
--- ```

---@type vim.lsp.Config
return {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
    init_options = {
        provideFormatter = true,
    },
}

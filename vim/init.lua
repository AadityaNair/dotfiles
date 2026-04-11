-- TODO: Investigate incremenatal selection? https://www.reddit.com/r/neovim/comments/1s9q0pi/incremental_selection_in_neovim_012/
-- TODO: Builtin plugins? https://neovim.io/doc/user/plugins/
-- TODO: Builtin Completions

-- Bare minimum builtin stuff to make experience tolerable.
-- All the fancy shit in the plugin/
-- This file should work even if everything else breaks.

vim.loader.enable() -- Performance dark magic: https://github.com/neovim/neovim/pull/22668

vim.g.python3_host_prog = "/usr/bin/python3"
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.mapleader = ","
vim.opt.number = true
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.ruler = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
-- vim.opt.showmode = true
-- vim.opt.hidden = true
-- add function to get length of line
vim.opt.clipboard = "unnamedplus" -- Integrate vim with system clipboard.

vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("n", ";", ":")
vim.cmd.packadd("nohlsearch") -- Builtin plugin: auto-clears search highlights when cursor moves
vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { silent = true }) -- Manual fallback to clear highlights immediately

vim.keymap.set("n", "<Leader>r", "<Cmd>edit!<CR>")

vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { silent = true })
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { silent = true })
vim.keymap.set("i", "<C-j>", "<Esc>:m .+1<CR>==gi", { silent = true })
vim.keymap.set("i", "<C-k>", "<Esc>:m .-2<CR>==gi", { silent = true })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true })

vim.cmd("cnoreabbrev W! w!")
vim.cmd("cnoreabbrev Q! q!")
vim.cmd("cnoreabbrev Qall! qall!")
vim.cmd("cnoreabbrev Wq wq")
vim.cmd("cnoreabbrev Wa wa")
vim.cmd("cnoreabbrev wQ wq")
vim.cmd("cnoreabbrev WQ wq")
vim.cmd("cnoreabbrev W w")
vim.cmd("cnoreabbrev Q q")
vim.cmd("cnoreabbrev Qall qall")

-- TODO: Create a function to also clean any plugins not installed anymore.
vim.api.nvim_create_user_command("PluginUpdate", function()
    vim.pack.update()
end, { desc = "Update all plugins" })

-- Copied from https://github.com/creativenull/dotfiles/blob/main/config/nvim/init.lua#L70-L80
-- Return to the previous cursor position.
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(args)
        if vim.b[args.buf].filetype == "commit" then
            return
        end

        local mark_line = vim.fn.line([['"]])
        local last_line = vim.fn.line("$")

        if mark_line >= 1 and mark_line <= last_line then
            vim.cmd([[normal! g`"]])
        else
            vim.cmd("normal! G")
        end
    end,
})

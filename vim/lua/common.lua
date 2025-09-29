-- Bare minimum I require from my vimrc.
-- Pls no plugins here. Things sould work in a bare installation

local module = {}

function module.setup()
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
    vim.keymap.set("n", "<leader><space>", ":nohlsearch<CR>", { silent = true })

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

    -- Copied from https://github.com/creativenull/dotfiles/blob/main/config/nvim/init.lua#L70-L80
    -- Return to the previous cursor position.
    vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function(args)
            -- TODO: When line is invalid, do something more intelligent, or go to the end.
            local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
            local not_commit = vim.b[args.buf].filetype ~= "commit"

            if valid_line and not_commit then
                vim.cmd([[normal! g`"]])
            end
        end,
    })
end

function module.TableConcat(t1, t2)
    for _, v in ipairs(t2) do
        require("table").insert(t1, v)
    end
    return t1
end

return module

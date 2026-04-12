vim.opt.termguicolors = true

local gh_url = require("common").gh_url

-- Colorscheme: Loaded at startup
vim.pack.add({
    gh_url("folke/tokyonight.nvim"),
})

require("tokyonight").setup({
    terminal_colors = true,
    styles = {
        comments = { italic = true },
        keywords = { italic = true },
    },
})

vim.cmd.colorscheme("tokyonight-night")

-- Lazy UI setup
local function setup_ui()
    vim.pack.add({
        gh_url("folke/todo-comments.nvim"), -- TODO: Replace with simple code.
        gh_url("nvim-lualine/lualine.nvim"), -- TODO: Replace with custom statusline
        gh_url("akinsho/bufferline.nvim"),
        gh_url("nvim-tree/nvim-web-devicons"),
    })

    require("lualine").setup({
        options = {
            theme = "tokyonight",
            icons_enabled = true,
            globalstatus = true,
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { "filename" },
            lualine_x = { "searchcount", "selectioncount", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    })

    require("bufferline").setup({
        options = { always_show_bufferline = false },
    })

    vim.opt.cmdheight = 0

    require("todo-comments").setup({
        signs = false,
        highlight = { multiline = false },
    })
end

-- Defer loading UI plugins until after the interface has drawn
vim.api.nvim_create_autocmd("UIEnter", {
    callback = function()
        vim.schedule(setup_ui)
    end,
    once = true,
})

-- NOTE: If UI2 cmdline/messages cause too many problems, fall back to
-- rachartier/tiny-cmdline.nvim (cmdline) and rcarriga/nvim-notify (notifications).

-- UI2: Route messages to bottom-right ephemeral msg window and center the cmdline.
local ui2 = require("vim._core.ui2")
ui2.enable({
    msg = { targets = "msg" },
})

-- Wrap msg set_pos so the msg window gets a border (UI2 defaults to no border for msg).
local msg_mod = require("vim._core.ui2.messages")
local orig_set_pos = msg_mod.set_pos
msg_mod.set_pos = function(tgt)
    orig_set_pos(tgt)
    local win = ui2.wins.msg
    if win and vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_set_config, win, { border = "rounded" })
    end
end

-- Show LSP progress as messages (Neovim 0.12 only fires LspProgress autocmds).
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value or {}
        if not client or not value.kind then
            return
        end
        local title = value.title or ""
        if value.kind == "begin" then
            vim.notify(string.format("[%s] %s", client.name, title))
        elseif value.kind == "end" then
            local msg = value.message or title
            vim.notify(string.format("[%s] %s", client.name, msg))
        end
    end,
})

-- Centered cmdline: monkey-patch ui2 cmdline_show/cmdline_hide to reposition the
-- cmd window to the center of the screen while active.
local cmdline_mod = require("vim._core.ui2.cmdline")
local orig_cmdline_show = cmdline_mod.cmdline_show
local orig_cmdline_hide = cmdline_mod.cmdline_hide

cmdline_mod.cmdline_show = function(content, pos, firstc, prompt, indent, level, hl_id)
    local ret = orig_cmdline_show(content, pos, firstc, prompt, indent, level, hl_id)
    local win = ui2.wins.cmd
    if win and vim.api.nvim_win_is_valid(win) then
        local cols = vim.o.columns
        local width = math.floor(cols * 0.5)
        local row = math.floor(vim.o.lines * 0.4)
        local col = math.floor((cols - width) / 2)
        local border_size = 2
        pcall(vim.api.nvim_win_set_config, win, {
            relative = "editor",
            row = row,
            col = col,
            width = width,
            border = "rounded",
            _cmdline_offset = 0,
        })
        vim.g.ui_cmdline_pos = { row + 1 + border_size, col + 1 }
    end
    return ret
end

cmdline_mod.cmdline_hide = function(level, abort)
    local ret = orig_cmdline_hide(level, abort)
    local win = ui2.wins.cmd
    if win and vim.api.nvim_win_is_valid(win) then
        pcall(vim.api.nvim_win_set_config, win, {
            relative = "laststatus",
            row = 0,
            col = 0,
            width = 10000,
            border = "none",
            _cmdline_offset = 0,
        })
    end
    vim.g.ui_cmdline_pos = nil
    return ret
end

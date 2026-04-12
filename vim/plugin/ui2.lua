-- NOTE: If UI2 cmdline/messages cause too many problems, fall back to
-- rachartier/tiny-cmdline.nvim (cmdline) and rcarriga/nvim-notify (notifications).

-- UI2: Route messages to bottom-right ephemeral msg window and center the cmdline.
local ui2 = require("vim._core.ui2")
ui2.enable({
    msg = { targets = "msg" },
})

-- Match the msg window background with the editor Normal highlight.
vim.api.nvim_create_autocmd("FileType", {
    pattern = "msg",
    callback = function()
        vim.wo.winhighlight = "Normal:Normal"
    end,
})

-- Wrap set_pos so the msg window width shrinks to fit current content.
-- UI2 only grows msg.width via math.max and never shrinks it, so a short
-- message after a long one leaves the window too wide (text looks left-aligned).
local msg_mod = require("vim._core.ui2.messages")
local orig_set_pos = msg_mod.set_pos
msg_mod.set_pos = function(tgt)
    if tgt == "msg" then
        local win = ui2.wins.msg
        local buf = ui2.bufs.msg
        if win and vim.api.nvim_win_is_valid(win) and buf and vim.api.nvim_buf_is_valid(buf) then
            local width = 1
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            for _, line in ipairs(lines) do
                width = math.max(width, vim.fn.strdisplaywidth(line))
            end
            msg_mod.msg.width = width
            pcall(vim.api.nvim_win_set_width, win, width)
        end
    end
    orig_set_pos(tgt)
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

-- Custom highlight for the cmdline border: FloatBorder fg with Normal bg.
local function setup_cmdline_hl()
    local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    local border_fg = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg
    vim.api.nvim_set_hl(0, "UI2CmdBorder", { fg = border_fg, bg = normal_bg })
end
setup_cmdline_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_cmdline_hl })

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
        vim.wo[win].winhighlight = "Normal:Normal,FloatBorder:UI2CmdBorder"
        vim.g.ui_cmdline_pos = { row + 1 + border_size, col + 1 }
        -- The original cmdline_show sets cmdheight=1 to make space for the native
        -- bottom bar. Since we float the cmdline to center, suppress that.
        vim._with({ noautocmd = true }, function()
            vim.o.cmdheight = 0
        end)
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

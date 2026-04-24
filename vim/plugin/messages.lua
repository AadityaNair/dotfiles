-- NOTE: If UI2 messages cause too many problems, fall back to
-- rcarriga/nvim-notify (notifications).

-- UI2 (Neovim 0.12+): replaces the builtin cmdline and message presentation layer
-- with floating windows we can customize. ext_messages intercepts all msg_show and
-- cmdline events before the TUI draws them.
--
-- targets = "msg" routes core Neovim messages (:echo, search counts, errors, etc.)
-- to the ephemeral "msg" floating window instead of the default "cmd" (bottom bar).
-- Without this, every message with cmdheight=0 triggers expand_msg and clobbers the
-- statusline. This only affects core messages — Lua-level vim.notify is handled
-- separately by the override below.
--
-- NOTE: An empty table {} is required even when using defaults. Neovim 0.12.0 has a
-- bug where enable() declares opts as optional via vim.validate but passes it directly
-- to vim.tbl_deep_extend, which chokes on nil. Fixed in 0.12.1.
local ui2 = require("vim._core.ui2")
ui2.enable({ msg = { targets = "msg" } })

-- Custom highlights: FloatBorder fg with Normal bg, recomputed on colorscheme change.
local function setup_ui2_hl()
    local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
    local border_fg = vim.api.nvim_get_hl(0, { name = "FloatBorder" }).fg
    vim.api.nvim_set_hl(0, "UI2Border", { fg = border_fg, bg = normal_bg })
    vim.api.nvim_set_hl(0, "UI2Title", { fg = border_fg, bg = normal_bg, italic = true })
end
setup_ui2_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = setup_ui2_hl })

-- Custom vim.notify override: one floating window per notification.
-- vim.notify is the Lua-level API used by plugins (e.g. LSP progress below).
-- It is independent of UI2's msg_show, which handles core Neovim messages
-- (:echo, search results, errors). Both systems coexist.
-- Each notification gets its own buffer so it can size independently and
-- dismiss on its own timer without affecting others.
local active_notifs = {}
local TIMEOUT = 4000

local function reposition_notifs()
    local row = vim.o.lines - 2
    for i = #active_notifs, 1, -1 do
        local notif = active_notifs[i]
        if vim.api.nvim_win_is_valid(notif.win) then
            local height = vim.api.nvim_win_get_height(notif.win)
            local width = vim.api.nvim_win_get_width(notif.win)
            pcall(vim.api.nvim_win_set_config, notif.win, {
                relative = "editor",
                anchor = "SE",
                row = row,
                col = vim.o.columns,
                width = width,
                height = height,
            })
            row = row - height
        end
    end
end

local function remove_notif(idx)
    local notif = active_notifs[idx]
    if not notif then
        return
    end
    if notif.timer and not notif.timer:is_closing() then
        notif.timer:stop()
        notif.timer:close()
    end
    if vim.api.nvim_win_is_valid(notif.win) then
        vim.api.nvim_win_close(notif.win, true)
    end
    if vim.api.nvim_buf_is_valid(notif.buf) then
        vim.api.nvim_buf_delete(notif.buf, { force = true })
    end
    table.remove(active_notifs, idx)
    reposition_notifs()
end

vim.notify = function(msg, level, opts)
    if vim.in_fast_event() then
        vim.schedule(function()
            vim.notify(msg, level, opts)
        end)
        return
    end

    local lines = vim.split(tostring(msg), "\n")
    local width = 1
    for _, line in ipairs(lines) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local win = vim.api.nvim_open_win(buf, false, {
        relative = "editor",
        anchor = "SE",
        row = vim.o.lines - 2,
        col = vim.o.columns,
        width = width,
        height = #lines,
        style = "minimal",
        focusable = false,
        noautocmd = true,
    })
    vim.wo[win].winhighlight = "Normal:Normal"

    local timer = vim.uv.new_timer()
    local idx = #active_notifs + 1
    timer:start(
        TIMEOUT,
        0,
        vim.schedule_wrap(function()
            for i, n in ipairs(active_notifs) do
                if n.win == win then
                    remove_notif(i)
                    return
                end
            end
        end)
    )

    active_notifs[idx] = { win = win, buf = buf, timer = timer }
    reposition_notifs()
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

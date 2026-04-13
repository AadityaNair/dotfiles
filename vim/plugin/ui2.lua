-- NOTE: If UI2 cmdline/messages cause too many problems, fall back to
-- rachartier/tiny-cmdline.nvim (cmdline) and rcarriga/nvim-notify (notifications).

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

-- Centered cmdline: monkey-patch UI2's cmdline_show/cmdline_hide handlers.
--
-- UI2 manages a single "cmd" floating window (ui2.wins.cmd) for the cmdline.
-- By default it sits at the bottom bar (relative = "laststatus"). We intercept
-- the show/hide handlers to reposition it to the center of the screen while
-- the cmdline is active, then restore the original position on hide.
--
-- This works because require() caches modules — cmdline_mod is the same table
-- as ui2's internal M.cmd, so swapping functions here affects the UI2 event
-- dispatch directly.
local cmdline_mod = require("vim._core.ui2.cmdline")
local orig_cmdline_show = cmdline_mod.cmdline_show
local orig_cmdline_hide = cmdline_mod.cmdline_hide

cmdline_mod.cmdline_show = function(content, pos, firstc, prompt, indent, level, hl_id)
    -- Let UI2 do its work first: set buffer text, highlight, cursor position.
    local ret = orig_cmdline_show(content, pos, firstc, prompt, indent, level, hl_id)
    -- Then reposition the cmd window from the bottom bar to screen center.
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
            title = { { " cmdline ", "UI2Title" } },
            title_pos = "center",
            _cmdline_offset = 0,
        })
        vim.wo[win].winhighlight = "Normal:Normal,FloatBorder:UI2Border"
        -- Expose position for other plugins (e.g. completion menus) that need to
        -- know where the cmdline is drawn. Accounts for border adding 2 rows.
        vim.g.ui_cmdline_pos = { row + 1 + border_size, col + 1 }
        -- The original cmdline_show calls win_config() which sets cmdheight=1 to
        -- reserve space for the native bottom bar. Since we float the cmdline to
        -- center, that space is unnecessary — suppress it without firing OptionSet
        -- (which would trigger UI2's own repositioning logic).
        vim._with({ noautocmd = true }, function()
            vim.o.cmdheight = 0
        end)
    end
    return ret
end

cmdline_mod.cmdline_hide = function(level, abort)
    -- Let UI2 clear the buffer, reset state, and hide the window.
    local ret = orig_cmdline_hide(level, abort)
    -- Restore the cmd window to its default bottom-bar position so that UI2's
    -- internal logic (check_targets, set_pos) finds it where it expects.
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

-- NOTE: If UI2 cmdline causes too many problems, fall back to
-- rachartier/tiny-cmdline.nvim (cmdline).

-- Guard: if this file is sourced more than once (e.g. :source, config reload),
-- the monkey-patch would wrap an already-wrapped function, causing duplicate
-- repositioning, broken state restore, and potential recursion.
if vim.g._cmdline_patched then
    return
end
vim.g._cmdline_patched = true

-- Centered cmdline: monkey-patch UI2's cmdline_show handler.
--
-- UI2 manages a single "cmd" floating window (ui2.wins.cmd) for the cmdline.
-- By default it sits at the bottom bar (relative = "laststatus"). We intercept
-- the show handler to reposition it to the center of the screen while the
-- cmdline is active, and use a CmdlineLeave autocmd to restore position.
--
-- Using CmdlineLeave + saved config instead of patching cmdline_hide is less
-- invasive (one monkey-patch instead of two) and avoids hardcoding UI2's
-- expected default config, which could silently drift with Neovim updates.
--
-- This works because require() caches modules — cmdline_mod is the same table
-- as ui2's internal M.cmd, so swapping functions here affects the UI2 event
-- dispatch directly.

-- Lazy-load ui2 internals via pcall to avoid hard crashes if Neovim's internal
-- module paths change. These are private APIs — defensive loading makes startup
-- more resilient and decouples us from UI2's initialization timing.
local ui2_mod = nil ---@type table|nil
local function get_cmd_win()
    if not ui2_mod then
        local ok, mod = pcall(require, "vim._core.ui2")
        if not ok then
            return nil
        end
        ui2_mod = mod
    end
    local win = ui2_mod.wins and ui2_mod.wins.cmd
    return (win and vim.api.nvim_win_is_valid(win)) and win or nil
end

local ok, cmdline_mod = pcall(require, "vim._core.ui2.cmdline")
if not ok then
    return
end
local orig_cmdline_show = cmdline_mod.cmdline_show

-- Geometry config with min/max clamping. A fixed percentage breaks on ultrawide
-- or very small terminals — clamping keeps the cmdline usable at any size.
local config = {
    width_pct = 0.5, -- fraction of vim.o.columns
    width_min = 40, -- minimum columns
    width_max = 80, -- maximum columns
    y_pct = 0.4, -- vertical position (fraction of vim.o.lines)
}

--- Compute centered geometry from config + current terminal dimensions.
local function geometry()
    local cols = vim.o.columns
    local lines = vim.o.lines
    local width = math.max(config.width_min, math.min(config.width_max, math.floor(cols * config.width_pct)))
    width = math.min(width, cols - 4) -- always leave some margin
    local row = math.floor(lines * config.y_pct)
    local col = math.floor((cols - width) / 2)
    return width, row, col
end

-- Snapshot of the cmd window's original config, captured once per cmdline
-- session and restored on CmdlineLeave. This avoids hardcoding UI2's default
-- layout (relative, row, col, width, border) which could change across versions.
local cmd_win_saved = nil ---@type table|nil

local function set_cmdheight_0()
    vim._with({ noautocmd = true, o = { splitkeep = "screen" } }, function()
        vim.o.cmdheight = 0
    end)
end

-- Reposition the cmd window to screen center. Extracted so it can be called
-- from both cmdline_show and resize/tab-change events.
local function reposition()
    local win = get_cmd_win()
    if not win or not cmd_win_saved then
        return
    end

    local width, row, col = geometry()
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
    -- Expose position for other plugins (e.g. completion menus) that need to
    -- know where the cmdline is drawn. Accounts for border adding 2 rows.
    vim.g.ui_cmdline_pos = { row + 1 + border_size, col + 1 }
end

cmdline_mod.cmdline_show = function(content, pos, firstc, prompt, indent, level, hl_id)
    -- Let UI2 do its work first: set buffer text, highlight, cursor position.
    local ret = orig_cmdline_show(content, pos, firstc, prompt, indent, level, hl_id)
    -- Then reposition the cmd window from the bottom bar to screen center.
    local win = get_cmd_win()
    if win then
        -- Save the original config once per session so we can restore it exactly
        -- on CmdlineLeave, rather than guessing what UI2 expects.
        if not cmd_win_saved then
            local current = vim.api.nvim_win_get_config(win)
            cmd_win_saved = {
                relative = current.relative,
                anchor = current.anchor,
                col = current.col,
                row = current.row,
                width = current.width,
                border = current.border,
            }
            vim.wo[win].winhighlight = "Normal:Normal,FloatBorder:UI2Border"
        end

        reposition()
        -- The original cmdline_show calls win_config() which sets cmdheight=1 to
        -- reserve space for the native bottom bar. Since we float the cmdline to
        -- center, that space is unnecessary — suppress it without firing OptionSet
        -- (which would trigger UI2's own repositioning logic).
        -- splitkeep="screen" prevents visible layout jumps in split-heavy layouts
        -- when cmdheight changes cause the screen to redistribute space.
        set_cmdheight_0()
    end
    return ret
end

local group = vim.api.nvim_create_augroup("cmdline-center", { clear = true })

vim.api.nvim_create_autocmd("CmdlineLeave", {
    group = group,
    callback = function()
        local win = get_cmd_win()
        -- Restore the original window config so post-command messages (e.g. echo
        -- output) render at the bottom and UI2's internal logic finds the window
        -- where it expects.
        if win and cmd_win_saved then
            pcall(vim.api.nvim_win_set_config, win, cmd_win_saved)
            cmd_win_saved = nil
        end
        vim.g.ui_cmdline_pos = nil
        -- Defer so ui2's OptionSet handler doesn't re-bump cmdheight after we
        -- clear it.
        vim.schedule(set_cmdheight_0)
    end,
})

-- Reposition the cmdline if the terminal is resized or the user switches tabs
-- while the cmdline is active — otherwise it stays at stale coordinates.
vim.api.nvim_create_autocmd({ "VimResized", "TabEnter" }, {
    group = group,
    callback = function()
        vim.schedule(reposition)
    end,
})

-- NOTE: If UI2 cmdline causes too many problems, fall back to
-- rachartier/tiny-cmdline.nvim (cmdline).

-- Guard: if this file is sourced more than once (e.g. :source, config reload),
-- the monkey-patch would wrap an already-wrapped function, causing duplicate
-- repositioning, broken state restore, and potential recursion.
if vim.g._cmdline_patched then
    return
end
vim.g._cmdline_patched = true

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
local ui2 = require("vim._core.ui2")
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

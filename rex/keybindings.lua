-- rex/keybindings.lua -- the complete keymap. Every binding in effect is here.
-- Docs: /rex/docs/customize/keyboard-shortcuts (rex.bind/unbind),
--   key-sequences (">" joins sequence keys), key-modes (removed -- no modes).
--
-- Priority: client defaults < this file < shortcuts set in the app.
-- Verified: no in-app shortcuts exist (nothing shortcut-shaped in the
-- com.superlogical.rex defaults domain), so this file IS the effective map
-- on top of the client's shipped defaults.
-- Debug: rex config check (syntax) + rex -C <label> keymap (merged view).

-- tmux-parity leader: ctrl+a then key (tmux.conf sets prefix C-a).
local function leader(key)
    return "ctrl+a>" .. key
end

-- Sessions.
rex.bind("ctrl+s", "session.switch")
rex.bind(leader("s"), "session.switch")
rex.bind(leader("shift+n"), "session.new")
rex.bind(leader("shift+4"), "session.rename")

-- Tabs (windows in Rex).
rex.bind(leader("c"), "client.tab.new")
rex.bind(leader(","), "client.tab.rename")
rex.bind(leader("h"), "client.tab.previous")
rex.bind(leader("l"), "client.tab.next")
rex.bind("alt+left", "client.tab.previous")
rex.bind("alt+right", "client.tab.next")
rex.bind(leader("alt+h"), "client.tab.move.backward")
rex.bind(leader("alt+l"), "client.tab.move.forward")

-- Panes.
rex.bind(leader("shift+5"), "pane.split", { direction = "right" })
rex.bind(leader("\\"), "pane.split", { direction = "right" })
rex.bind(leader("-"), "pane.split", { direction = "down" })
rex.bind(leader("shift+'"), "pane.split", { direction = "down" })
rex.bind(leader("left"), "pane.focus.left")
rex.bind(leader("right"), "pane.focus.right")
rex.bind(leader("up"), "pane.focus.up")
rex.bind(leader("down"), "pane.focus.down")
rex.bind("shift+left", "pane.focus.left")
rex.bind("shift+right", "pane.focus.right")
rex.bind("shift+up", "pane.focus.up")
rex.bind("shift+down", "pane.focus.down")
rex.bind(leader("x"), "pane.close")
rex.bind(leader("z"), "pane.zoom")
rex.bind(leader("="), "pane.balance")
-- Resize without a mode: leader+alt+arrows, shift for bigger steps.
rex.bind(leader("alt+left"), "pane.resize", { direction = "left" })
rex.bind(leader("alt+right"), "pane.resize", { direction = "right" })
rex.bind(leader("alt+up"), "pane.resize", { direction = "up" })
rex.bind(leader("alt+down"), "pane.resize", { direction = "down" })
rex.bind(leader("alt+shift+left"), "pane.resize", { direction = "left", amount = 15 })
rex.bind(leader("alt+shift+right"), "pane.resize", { direction = "right", amount = 15 })
rex.bind(leader("alt+shift+up"), "pane.resize", { direction = "up", amount = 15 })
rex.bind(leader("alt+shift+down"), "pane.resize", { direction = "down", amount = 15 })

-- Font size + find (direct binds to client actions, no custom action needed).
rex.bind("cmd+=", "client.font.increase")
rex.bind("cmd+-", "client.font.decrease")
rex.bind("cmd+0", "client.font.reset")
rex.bind("shift+cmd+e", "client.find.open")

-- Keyboard copy mode (Mac preview.32+): cursor through scrollback with vim
-- keys, yank without the mouse. Mirrors tmux copy mode: our tmux.conf uses
-- M-p, universal tmux default is prefix+[ (paste is prefix+]).
-- Inside the mode the client's own keys apply; rebind those with `copy/`
-- bindings here if needed (same pattern as the old resize/ mode), e.g.:
--   rex.bind("copy/j", "pane.copy_mode.move", { to = "down" })
rex.bind("alt+p", "pane.copy_mode.enter")
rex.bind(leader("["), "pane.copy_mode.enter")
rex.bind(leader("]"), "pane.paste")

-- Applies the SETTINGS list in client_settings.lua.
rex.bind(leader("shift+a"), "apply_settings")

-- DISABLED DEFAULTS.
-- Nothing is unbound right now, deliberately: every default this file
-- shadows is already overridden by binding it above (a bind always wins
-- over the client's default for the same key -- no unbind needed first),
-- and keys we don't bind keep their default meaning or fall through to
-- the terminal, which is what we want.
-- Shipped defaults cannot be enumerated from the CLI (only the client
-- knows them; `rex keymap --request` needs the client's own request), so
-- nothing is unbound blindly. To neutralize a default later, add e.g.:
--   rex.unbind("cmd+k")                      -- key falls through to terminal
--   rex.unbind("cmd+t", "client.tab.new")    -- only when bound to that action
-- then re-check with: rex config check && rex -C Darkstar keymap

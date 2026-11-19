-- rex/client_settings.lua -- client-level settings, as data.
-- Docs: Lua API rex.client.queue, Custom Actions > Calling Other Actions,
--   Mac Settings + Mac Actions references.
--
-- There is NO client.setup() table. Appearance, theme, font, padding etc.
-- are client *actions* (client.setting.*, client.theme.*, …). This file
-- declares them as a plain list (SETTINGS) and applies them via
-- helpers.apply_client_settings, inside the apply_settings action below.
-- Run it with the bound key, or:  rex do apply_settings
-- (needs a connected client with Remote Control on -- it is on here).
--
-- Every value below is the CURRENT live value, picked up from this Mac:
--   defaults read com.superlogical.rex   (Workspace.* keys -- noted per entry)
-- Arg shapes verified against:  rex -C Darkstar actions --json
-- Anything whose current value is not observable, or has no setting action,
-- is listed under INTENTIONALLY UNMANAGED, not silently defaulted.

local helpers = require("helpers")

local SETTINGS = {
    -- Notifications (Mac Settings > Notifications).
    { action = "client.setting.notifications.overview.position", args = { value = "bottom-right" } }, -- Workspace.notificationPosition
    { action = "client.setting.notifications.macos.terminal_notifications", args = { value = true } }, -- Workspace.allowsTerminalNotifications = 1

    -- Interface > Toolbar / Tabs (Mac Settings > Interface).
    { action = "client.setting.interface.toolbar.auto_hide_toolbar", args = { value = "always_show" } }, -- Workspace.toolbarBehavior
    { action = "client.setting.interface.tab_behavior.fill", args = { value = false } }, -- Workspace.tabsFillAvailableSpace = 0
    { action = "client.setting.interface.tabs.color", args = { value = "active_panes" } }, -- Workspace.tabIconColorMode
    { action = "client.setting.interface.tabs.shell_icon_theme", args = { value = "theme" } }, -- Workspace.shellIconTheme = themed
    { action = "client.setting.interface.tabs.count", args = { value = 2 } }, -- Workspace.tabIconCount

    -- Interface > Panes / Padding / Active pane.
    { action = "client.setting.interface.panes.density", args = { value = "compact" } }, -- Workspace.paneDensity
    { action = "client.setting.interface.panes.headers", args = { value = "on_hover" } }, -- Workspace.paneHeaderVisibility
    { action = "client.setting.interface.pane_padding.horizontal", args = { value = 0 } }, -- Workspace.terminalPaddingX
    { action = "client.setting.interface.pane_padding.program_background", args = { value = true } }, -- Workspace.tintsPanesWithProgramBackground = 1
    { action = "client.setting.interface.active_panes.active_border", args = { value = true } }, -- Workspace.showsActivePaneBorder = 1
    { action = "client.setting.interface.active_panes.active_border_animation", args = { value = "fade" } }, -- Workspace.activePaneBorderTransition
    { action = "client.setting.interface.active_panes.fade", args = { value = "off" } }, -- Workspace.inactivePaneFadeMode = none
    { action = "client.setting.interface.active_panes.inactive_window", args = { value = false } }, -- Workspace.usesStandardInactiveWindowPaneStyles = 0
    { action = "client.setting.interface.splits_focus.autobalance", args = { value = true } }, -- Workspace.balancesSplitsOnCreation = 1
    { action = "client.setting.interface.splits_focus.focus_follows_mouse", args = { value = true } }, -- Workspace.focusFollowsMouse = 1
    { action = "client.setting.interface.animation.style", args = { value = "natural" } }, -- Workspace.animationStyle

    -- Themes (Mac Settings > Themes). Dark name decoded from
    -- Workspace.customThemes (id custom-3D51F411-… = flexoki-dark).
    { action = "client.setting.themes.light.palette", args = { value = "merino-light" } }, -- Workspace.lightThemeID
    { action = "client.setting.themes.dark.palette", args = { value = "flexoki-dark" } }, -- Workspace.darkThemeID

    -- Terminal > Typography / Fonts.
    { action = "client.setting.terminal.typography.font", args = { value = "JetBrainsMono Nerd Font Mono" } }, -- Workspace.terminalFontName
    { action = "client.setting.terminal.typography.size", args = { value = 16 } }, -- Workspace.terminalFontPointSize
    { action = "client.setting.terminal.typography.line_height", args = { value = 0 } }, -- Workspace.terminalCellHeightPercent
    { action = "client.setting.terminal.advanced_fonts.ligatures", args = { value = true } }, -- Workspace.terminalAllowsLigatures = 1
    { action = "client.setting.terminal.advanced_fonts.smoothing", args = { value = false } }, -- Workspace.terminalFontSmoothing = 0

    -- Terminal > Colors / Cursor / Keyboard / Scrolling / Selection / Titles.
    { action = "client.setting.terminal.colors.contrast", args = { value = true } }, -- Workspace.terminalImproveTextContrast = 1
    { action = "client.setting.terminal.colors.palette", args = { value = false } }, -- Workspace.terminalUseThemePalette = 0
    { action = "client.setting.terminal.colors.display_p3", args = { value = true } }, -- Workspace.terminalUsesDisplayP3 = 1
    { action = "client.setting.terminal.cursor.style", args = { value = "block" } }, -- Workspace.terminalCursorStyle
    { action = "client.setting.terminal.cursor.interval", args = { value = 500 } }, -- Workspace.terminalCursorBlinkIntervalMilliseconds (non-custom)
    { action = "client.setting.terminal.cursor.shaders", args = { value = false } }, -- Workspace.cursorShadersEnabled = 0
    { action = "client.setting.terminal.cursor.shader", args = { value = "sweep" } }, -- Workspace.cursorShader
    { action = "client.setting.terminal.keyboard.option", args = { value = "automatic" } }, -- Workspace.terminalOptionKeyBehavior
    { action = "client.setting.terminal.scrolling.smooth", args = { value = true } }, -- Workspace.terminalSmoothScrolling = 1
    { action = "client.setting.terminal.selection.copy_on_select", args = { value = true } }, -- Workspace.terminalCopyOnSelect = 1
    { action = "client.setting.terminal.selection.foreground", args = { value = "theme" } }, -- Workspace.terminalSelectionForeground
    { action = "client.setting.terminal.selection.corners", args = { value = true } }, -- Workspace.terminalSelectionRoundedCorners = 1
    { action = "client.setting.terminal.titles.prefer_generated", args = { value = false } }, -- Workspace.prefersGeneratedTitles = 0

    -- Developer (rex.developer-mode-enabled = true in app defaults).
    { action = "client.setting.developer.mode.enabled", args = { value = true } },
    { action = "client.setting.developer.experimental.terminal_anchor", args = { value = "top" } }, -- Workspace.experiments.terminalGridAnchor
    { action = "client.setting.developer.experimental.new_quick_switcher", args = { value = true } }, -- Workspace.experiments.usesNewQuickSwitcher = 1
}

-- INTENTIONALLY UNMANAGED (left at whatever the app has; add above with a
-- verified value if you want them pinned):
--   appearance.scheme/style/tint/glass (Workspace.interfaceStyle = useTheme
--     has no matching setting action; style/tint/glass values unobservable)
--   toolbar.layout, window.sidebar_text_size/window_width/sidebar_swipe,
--     pane_padding.vertical/color (stored "extend" has no documented
--     equivalent), active_border_color/opacity, app_icon.*,
--     launch.show_window, gestures.use_gestures, themes.*.extended_palette
--   typography.style, advanced_fonts.character_spacing/bold_italic/
--     synthesize/fallback_fonts, cursor.blink (preset unknown; only the
--     500ms interval above is stored), cursor.force, scrolling.resizing,
--     selection.play_animation_on_copy/background, links.custom_schemes,
--     path_browser.recent_paths, shell.command, remote_hosts.ssh.*
--   all notifications.activity.* (tab_activity, sounds, dock_badge,
--     status_working/blocked/error/done -- no stored values to pick up)

rex.action({
    name = "apply_settings",
    title = "Apply Pinned Client Settings",
    description = "Queues every entry in SETTINGS at the top of client_settings.lua.",
    category = "Settings",
    keywords = "settings apply pinned client",
    run = function(_ctx, _args)
        helpers.apply_client_settings(SETTINGS)
    end,
})

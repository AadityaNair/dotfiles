-- TODO: Move to nvim 0.12: plugin-manager
-- TODO: Evaluate all the current plugins
-- TODO: Move to autoloading configs as described in https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack.html#many-vim-pack-add
-- TODO: Profile startup time

local common = require("common")
local TableConcat = common.TableConcat

common.setup()
------------------------------------------------- Plugins Setup --------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

local ui = require("ui")
local ux = require("ux")
local coding = require("coding")

-- TODO: Auto load this file if it exists. Avoids leaving a dirty repo.
local company = require("company")

local plugins = {}

plugins = TableConcat(plugins, ui.plugins)
plugins = TableConcat(plugins, ux.plugins)
plugins = TableConcat(plugins, coding.plugins)
plugins = TableConcat(plugins, company.plugins)

require("lazy").setup({
    spec = plugins,
    rocks = {
        enabled = false,
    },
})

ui.setup()
ux.setup()
coding.setup()
company.setup()

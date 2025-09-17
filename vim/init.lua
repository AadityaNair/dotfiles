--  luochen1990/rainbow             -> https://gitlab.com/HiPhish/rainbow-delimiters.nvim
--  mbbill/undotree                 -> debugloop/telescope-undo.nvim
--  terryma/vim-multiple-cursors    -> mg979/vim-visual-multi (?X)

local common = require('common')
local TableConcat = common.TableConcat

common.setup()
------------------------------------------------- Plugins Setup --------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

local ui = require("ui")
local ux = require("ux")
local autocomplete = require("autocomplete")

-- TODO: Auto load this file if it exists. Avoids leaving a dirty repo.
local company = require("company_specific_config")

local plugins = {}

plugins = TableConcat(plugins, ui.plugins)
plugins = TableConcat(plugins, ux.plugins)
plugins = TableConcat(plugins, autocomplete.plugins)
plugins = TableConcat(plugins, company.plugins)

require('lazy').setup(plugins)

ui.setup()
ux.setup()
autocomplete.setup()
company.setup()

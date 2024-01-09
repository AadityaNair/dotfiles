-- Rewrite init.vim to init.lua. 
-- Plugin manager: lazy.vim
-- Plugins:
--  shougo/deoplete.nvim            -> hrsh7th/nvim-cmp (?X)
--  easymotion/vim-easymotion       -> ggandor/leap.nvim 
--  luochen1990/rainbow             -> https://gitlab.com/HiPhish/rainbow-delimiters.nvim
--  mbbill/undotree                 -> debugloop/telescope-undo.nvim
--  romainl/flattened               -> svrana/neosolarized.nvim (??)
--  scrooloose/nerdcommenter        -> numToStr/Comment.nvim
--  terryma/vim-multiple-cursors    -> mg979/vim-visual-multi (?X)
--  vim-airline/vim-airline         -> nvim-lualine/lualine.nvim
--  vim-airline/vim-airline-themes  -> XX

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- TODO: We shouldn't be bootstrapping plugins.
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- require("lazy").setup(plugins, opts)

vim.g.mapleader = ","

-- TODO: Some plugins require additional configuration
-- TODO: Try to load a plugin along with its configuration. Maybe not possible.
require("lazy").setup({
  "ggandor/leap.nvim",
  "nvim-lualine/lualine.nvim",
  "Tsuzat/NeoSolarized.nvim",
  "numToStr/Comment.nvim",
})

vim.cmd[[colorscheme NeoSolarized]]
require('lualine').setup {
  options = { theme  = "solarized_dark" },
}
require('leap').create_default_mappings()

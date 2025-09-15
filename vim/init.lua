--  luochen1990/rainbow             -> https://gitlab.com/HiPhish/rainbow-delimiters.nvim
--  mbbill/undotree                 -> debugloop/telescope-undo.nvim
--  terryma/vim-multiple-cursors    -> mg979/vim-visual-multi (?X)


----------------------------------------------------  Other configuration   ------------------------------------------

vim.g.python3_host_prog="/usr/bin/python3"
vim.g.loaded_node_provider=0
vim.g.loaded_perl_provider=0
vim.g.loaded_python_provider=0

vim.g.mapleader = ","
vim.opt.number = true
vim.opt.textwidth = 0
vim.opt.wrapmargin = 0
vim.opt.ruler = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
-- vim.opt.showmode = true
-- vim.opt.hidden = true
-- add function to get length of line
vim.opt.clipboard = 'unnamedplus'  -- Integrate vim with system clipboard.

vim.keymap.set('i', 'kj', '<Esc>')
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', '<leader><space>', ':nohlsearch<CR>', {silent = true})

vim.keymap.set('n', '<Leader>r', '<Cmd>edit!<CR>')

vim.keymap.set('n','<C-j>',':m .+1<CR>==',{silent = true})
vim.keymap.set('n','<C-k>',':m .-2<CR>==',{silent = true})
vim.keymap.set('i','<C-j>','<Esc>:m .+1<CR>==gi',{silent = true})
vim.keymap.set('i','<C-k>','<Esc>:m .-2<CR>==gi',{silent = true})
vim.keymap.set('v','<C-j>',":m '>+1<CR>gv=gv",{silent = true})
vim.keymap.set('v','<C-k>',":m '<-2<CR>gv=gv",{silent = true})

vim.cmd('cnoreabbrev W! w!')
vim.cmd('cnoreabbrev Q! q!')
vim.cmd('cnoreabbrev Qall! qall!')
vim.cmd('cnoreabbrev Wq wq')
vim.cmd('cnoreabbrev Wa wa')
vim.cmd('cnoreabbrev wQ wq')
vim.cmd('cnoreabbrev WQ wq')
vim.cmd('cnoreabbrev W w')
vim.cmd('cnoreabbrev Q q')
vim.cmd('cnoreabbrev Qall qall')

-- Copied from https://github.com/creativenull/dotfiles/blob/9ae60de4f926436d5682406a5b801a3768bbc765/config/nvim/init.lua#L70-L86
-- Return to the previous cursor position.
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function(args)
    local valid_line = vim.fn.line([['"]]) >= 1 and vim.fn.line([['"]]) < vim.fn.line('$')
    local not_commit = vim.b[args.buf].filetype ~= 'commit'

    if valid_line and not_commit then
      vim.cmd([[normal! g`"]])
    end
  end,
})

------------------------------------------------- Plugins Setup --------------------------------------------------

-- TODO: vista.vim
-- TODO: When there is an error, the error window goes away too fast to actually read the thing.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
vim.opt.rtp:prepend(lazypath)

-- TODO: Avoid needing to updated the in-repo config file.
--       I want to avoid leaving a dirty repo.
company = require("company_specific_config")

plugins = {
    "nvim-lualine/lualine.nvim",
    {"folke/tokyonight.nvim", lazy=false, priority=1000,},
    "numToStr/Comment.nvim",
    'nvim-treesitter/nvim-treesitter',
    'nvim-treesitter/nvim-treesitter-context',
    {
        "neovim/nvim-lspconfig",
        dependencies = { 'saghen/blink.cmp' },
        config = function(_, opts)
            local lspconfig = require('lspconfig')
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            -- TODO: Not have per-server level capabilities
            lspconfig['lua_ls'].setup({capabilities = capabilities})
        end
    },
    {
        "saghen/blink.cmp",
        dependencies = {},
        version = "*",
        opts = {
            -- TODO: Tab to iterate through options
            keymap = {preset = "default"},
            appearance = {
                nerd_font_variant = "mono",
            },
            completion = { documentation = { auto_show = false } },
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        -- TODO: Move this to a different keymap call elsewhere,
        -- TODO: Look into more configuration
        keys = {{"s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash"},},
    },
    {'folke/todo-comments.nvim', dependencies = "nvim-lua/plenary.nvim" },
    {'akinsho/bufferline.nvim', dependencies = 'nvim-tree/nvim-web-devicons'},
    { "lukas-reineke/indent-blankline.nvim", main = "ibl" },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {}, -- Apparently this line is important
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
    {
        -- TODO: Find an alternative undotree impl and remove telescope entirely
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'debugloop/telescope-undo.nvim',
        },
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {"kevinhwang91/promise-async"},
    },

}

-- List all the plugins from the company specific code and add it to default list.
-- Only when company.plugin is set.
if company.plugin then
    len = require("table").getn(plugins)

    for index, entry in pairs(company.plugin) do
        plugins[len+index] = entry
    end
end

require('lazy').setup(plugins)
----------------------------------------------------- UI Improvements ----------------------------------------------


require("tokyonight").setup({
    terminal_colors = true,
    styles = {
    -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
  },
})


vim.opt.termguicolors = true
vim.cmd.colorscheme("tokyonight-night")
require('lualine').setup {
    options = {
        theme  = "tokyonight",
        icons_enabled = true,
        globalstatus = true,
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'searchcount', 'selectioncount', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    extensions = {'lazy'},
}
require("bufferline").setup({
    options = {always_show_bufferline = false,},
})
-- TODO: Maybe it is better if the notifications are on the bottom right
--       And without a box like in fidget.nvim. Investigate
-- TODO: Have a way to hold the notification for some time.
require("notify").setup({
    background_colour = "#000000",
    top_down = true,
    render = 'minimal',
    stages = 'fade',
})
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

-- TODO: Few more possibilities here. We don't need to to look too much different than comments.
require("todo-comments").setup({
    signs = false,
})

------------------------------------------------ Quality of Life ------------------------------------------

vim.o.foldcolumn = 'auto:9' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- TODO: Look into collapsing CPP namespaces automatically. And not having indents for it as well.
-- TODO: Add command to just fold the current fold
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

-- TODO: Only generate indentlines when there are more than two lines indented.
require('ibl').setup({
    indent = {char='│'},
})
-- TODO: This can use a good looking at.
require('Comment').setup({
    padding = true,
    sticky = true,
    toggler = {
        line = '<leader>ci'
    },
    opleader = {
        line = '<leader>ci'
    },
    mappings = {
        basic = true,
        extra = false,
    },
})

-- Custom commentstrings
local ft = require('Comment.ft')
ft.set('kdl', '//%s')

local telescope = require('telescope')

telescope.setup({
    extensions = {
        undo = {
            mappings = {
                i = {["<CR>"] = require("telescope-undo.actions").restore},
                n = {["<CR>"] = require("telescope-undo.actions").restore},
            },
            -- layout_strategy = "vertical",
            side_by_side=true,
        },
    },
})
telescope.load_extension "undo"
vim.keymap.set('n', 'u', telescope.extensions.undo.undo, {silent=true})

-- TODO: nvim-treesitter/nvim-treesitter-textobjects
require("nvim-treesitter.install").prefer_git = true
-- TODO: Finetune the values below.
require("treesitter-context").setup({
    enable=true,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
})
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        'bash',
        'c',
        'cpp',
        'diff',
        'erlang',
        'fish',
        'go',
        'graphql',
        'hack',
        'javascript',
        'json',
        'kdl',
        'lua',
        'markdown',
        'markdown_inline',
        'php',
        'python',
        'regex',
        'ruby',
        'rust',
        'starlark',
        'thrift',
        'toml',
        'vim',
        'vimdoc',
        'yaml',
    },
    highlight = {
        enable = true,
        -- disable = {'bash'},
    },
    indent = {
        enable = true,
        -- disable = {'latex'},
    },
})

-- Set strings to be italics
hl_settings = vim.api.nvim_get_hl(0, {name="String"})
hl_settings['italic']=true
vim.api.nvim_set_hl(0, "String", hl_settings)

------------------------------------------------------ Auto Complete -------------------------------

-- Set the right filetypes for zsh
vim.filetype.add({
    extension = {
        ['zsh'] = 'sh',
    },
    filename = {
        ['zshrc'] = 'sh',
    },
})

vim.api.nvim_create_user_command("DiagnosticToggle", function()
    local config = vim.diagnostic.config
    local vt = config().virtual_text
	config {
		virtual_text = not vt,
		underline = not vt,
		signs = not vt,
	}
end, {desc = "Toggle showing LSPErrors/Hints/etc"}
)
company.setup()

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- No swap file recovery
vim.opt.swapfile = false

-- Visual 
vim.cmd.colorscheme "catppuccin-mocha"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3 
vim.opt.wrap = false
vim.opt.fillchars:append { diff = "/" }
vim.opt.signcolumn = 'yes'  -- avoid annoying layout shift

-- Tab Configurations
vim.opt.tabstop = 4         -- Insert 4 spaces for tabs
vim.opt.shiftwidth = 4      -- Number of space characters inserted for indentation
vim.opt.expandtab = true    -- convert tabs to spaces

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Custom Keymaps
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
-- Shift text up/down
vim.keymap.set('n', '<M-j>', ":m .+1<CR>==")
vim.keymap.set('n', '<M-k>', ":m .-2<CR>==")
vim.keymap.set('i', '<M-j>', "<Esc>:m .+1<CR>==gi")
vim.keymap.set('i', '<M-k>', "<Esc>:m .-2<CR>==gi")
vim.keymap.set('v', '<M-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<M-k>', ":m '<-2<CR>gv-gv")
-- Keep cursor in same place when 1/2 page jumping
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
-- Keep copied buffer when overwriting
vim.keymap.set('x', '<leader>p', "\"_dP")
vim.keymap.set('n', '<leader>d', "\"_d")
vim.keymap.set('v', '<leader>d', "\"_d")
-- Neovim yank and System Clipboard yank
vim.keymap.set('n', '<leader>y', "\"+y")
vim.keymap.set('v', '<leader>y', "\"+y")
vim.keymap.set('n', '<leader>Y', "\"+Y")
-- Ignore Q
vim.keymap.set('n', 'Q', '<nop>')
-- Show diagnostics
vim.keymap.set('n', '<leader>e', function()
    vim.diagnostic.open_float()
end, { noremap = true, silent = true })

-- File types
vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- Better syntax highlighting
        { 'nvim-treesitter/nvim-treesitter',
            build = ":TSUpdate",
            config = function()
                local configs = require('nvim-treesitter.configs')
                configs.setup({
                    ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "go"},
                    sync_install = false,
                    auto_install = true,
                    highlight = { enable = true },
                    indent = { enable = true },
                })
            end
        },

        -- Coloscheme
        { 'catppuccin/nvim',
            name = 'catppuccin',
            priority = 1000 },

        -- File explorer
        { 'stevearc/oil.nvim',
            opts = {},
            keys = {
                {"-", "<CMD>Oil --float<CR>", desc = "Open parent directory" }
            },
            dependencies = {
                'nvim-tree/nvim-web-devicons'
            }},

        -- Auto bracket pairs
        { 'windwp/nvim-autopairs',
            event = 'InsertEnter',
            config = true },

        -- Nicer status line
        { 'nvim-lualine/lualine.nvim',
            dependencies = {
                'nvim-tree/nvim-web-devicons'
            }},

        -- fzf lua fuzzy finder
        { 'ibhagwan/fzf-lua',
            dependencies = {
                'nvim-tree/nvim-web-devicons'
            },
            opts = {
                winopts = {
                    height = .3,
                    width = 1,
                    row = 1,
                },
            },
            keys = {
                {'<leader>p', function() require('fzf-lua').files() end, silent = true},
            }},

        -- LSP and autocomplete
        { 'VonHeikemen/lsp-zero.nvim', branch = 'v4.x'},
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'hrsh7th/nvim-cmp' },
        { 'williamboman/mason.nvim', config = true },
        { 'williamboman/mason-lspconfig.nvim',
            opts = {
                ensure_installed = { 'lua_ls', 'rust_analyzer', 'clangd', 'gopls', 'sqls', 'zls' },
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            },
    	},

    },
    -- Configure any other settings here.

    -- automatically check for plugin updates
    checker = { enabled = true }
})

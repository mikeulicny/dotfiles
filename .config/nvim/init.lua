-- Plugin manager, will bootstrap packer install if not already installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()
require('plugins')

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

-- Tab Configurations
vim.opt.tabstop = 4         -- Insert 4 spaces for tabs
vim.opt.shiftwidth = 4      -- Number of space characters inserted for indentation
vim.opt.expandtab = true    -- convert tabs to spaces

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Custom Keymaps
vim.g.mapleader = ' '
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')
-- Shift text up/down
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv-gv")
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

-- Start LuaLine
require('lualine').setup{}

-- LSP Config
local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup()

-- Treesitter Config
require('nvim-treesitter.configs').setup {
    ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "go", "haskell", "svelte" },
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- Oil file manager
require("oil").setup({
    float = {
        max_width = 150,
        max_height = 50,
    },
})
vim.keymap.set('n', '-', "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

-- fzf lua config
require('fzf-lua').setup {
    winopts = {
        height = .3,
        width = 1,
        row = 1,
    }
}
-- open fzf
vim.keymap.set('n', '<leader>p', function() require('fzf-lua').files() end, { silent = true })

-- Autopairs rules
require('nvim-autopairs').setup({})

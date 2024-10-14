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

-- Source lazy.nvim plugin files
require("lazy").setup('plugins')

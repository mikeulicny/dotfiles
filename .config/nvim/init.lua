-- No swap file recovery
vim.opt.swapfile = false

-- Visual
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 3
vim.opt.wrap = false
vim.opt.winborder = "rounded"
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Tab Configurations
vim.opt.tabstop = 4      -- Insert 4 spaces for tabs
vim.opt.shiftwidth = 4   -- Number of space characters inserted for indentation
vim.opt.expandtab = true -- convert tabs to spaces

-- Window splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Nicer autocomplete
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Custom Keymaps
vim.g.mapleader = ' '
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
-- Better buffer delete
vim.keymap.set('n', '<leader>q', ":bp<bar>sp<bar>bn<bar>bd<CR>")
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

-- Packages
vim.pack.add({
    { src = "https://github.com/webhooked/oscura.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/akinsho/bufferline.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
})

require "mason".setup()
require "oil".setup({
    watch_for_changes = true,
    show_hidden = true,
    float = { max_width = 150, max_height = 40 },
})
require("nvim-treesitter").install({ 'c', 'eelixir', 'elixir', 'heex', 'lua', 'ruby', 'svelte', 'go', 'zig' }):wait(500)
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'elixir', 'lua', 'ruby', 'go', 'zig' },
    callback = function()
        vim.treesitter.start()
    end,
})
require "bufferline".setup()
require "fzf-lua".setup({'default'})

-- Package specific keymaps
vim.keymap.set('n', "-", "<CMD>Oil --float<CR>")
vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
vim.keymap.set('n', '<C-p>', '<CMD>FzfLua files<CR>', { silent=true })
vim.keymap.set('n', '<S-l>', '<CMD>bn<CR>')
vim.keymap.set('n', '<S-h>', '<CMD>bp<CR>')

vim.lsp.enable({ "bashls", "clangd", "html", "htmx", "gopls", "expert", "lua_ls", "svelte-language-server", "tailwindcss" })
vim.lsp.config("lua_ls", { settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true), } } } })

-- Treesitter highlighting
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'c', 'ex', 'heex', 'html', 'css', 'go', 'lua', 'svelte' },
    callback = function() vim.treesitter.start() end,
})

-- 2 space indents in html style filetypes
vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'css', 'html', 'svelte' },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
    end,
})

-- Colorscheme
require "oscura".setup({})
vim.cmd.colorscheme "oscura"

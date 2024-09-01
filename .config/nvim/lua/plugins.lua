-- Package Manager
return require('packer').startup(function(use)
    -- Have packer manage itself
    use { 'wbthomason/packer.nvim' }

    -- Better syntax highlighting
    use { 'nvim-treesitter/nvim-treesitter',
    	run = ':TSUpdate'
    }

    -- Auto bracket pairs
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("nvim-autopairs").setup {} end
    }

    -- File explorer
    use { 'stevearc/oil.nvim',
        config = function() require("oil").setup() end
    }

    -- Use nicer status line
    use { 'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }

    -- fzf lua fuzzy finder
    use { 'ibhagwan/fzf-lua' }

    -- Git diffview
    use { "sindrets/diffview.nvim" }

    -- Catpuccin color theme
    use { "catppuccin/nvim", as = "catppuccin" }

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- required
            {                            -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},     -- Required
            {'hrsh7th/cmp-nvim-lsp'}, -- Required
            {'L3MON4D3/LuaSnip'},     -- Required
        }
    }
end)

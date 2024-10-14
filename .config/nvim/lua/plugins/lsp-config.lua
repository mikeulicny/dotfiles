return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    lazy = true,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.opt.signcolumn = 'yes'
    end
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    config = function()
      require('mason-lspconfig').setup({
        auto_install = true,
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end
        },
      })
    end,
  },
}

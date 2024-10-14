return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v4.x',
    lazy = true,
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
    lazy = true,
    config = function()
      require('mason-lspconfig').setup({
        automatic_installation = true,
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end
        },
      })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.opt.signcolumn = 'yes'
    end
  },
}

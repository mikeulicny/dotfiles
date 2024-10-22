return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
      require('mason').setup()
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    lazy = false,
    opts = {
      automatic_installation = true,
      handlers = {
        function (server_name)
          require('lspconfig')[server_name].setup({})
        end,
      }
    },
  },
  {
    'neovim/nvim-lspconfig',
    version = "v1.0.0",
    config = function()
      vim.opt.signcolumn = 'yes'
    end,
  },
}

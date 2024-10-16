return {
  {
    'neovim/nvim-lspconfig',
    config = function()
      vim.opt.signcolumn = 'yes'
      require('mason').setup()
      require('mason-lspconfig').setup()
    end
  },
  {
    'williamboman/mason.nvim',
    lazy = false,
    config = function()
    end
  },
  {
    'williamboman/mason-lspconfig.nvim',
    lazy = false,
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = {'lua_ls', 'rust_analyzer', 'gopls', 'clangd'},
        automatic_installation = true,
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup({})
          end,
        },
      })
    end,
  },
}

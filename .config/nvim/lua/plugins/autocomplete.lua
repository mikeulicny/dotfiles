return {
  {
    'hrsh7th/cmp-nvim-lsp'
  },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        sources = {
          {name = 'nvim_lsp'},
        },
        snippet = {},
        window = {},
        mapping = cmp.mapping.preset.insert({}),
      })
    end
  },
}

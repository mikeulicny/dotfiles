return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    winopts = {
      height = .3,
      width = 1,
      row = 1,
    },
  },
  keys = {
      {'<leader>p', function() require('fzf-lua').files() end, silent = true},
  }
}

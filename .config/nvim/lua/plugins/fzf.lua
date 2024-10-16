return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
      {'<leader>p', function() require('fzf-lua').files() end, silent = true},
  },
  opts = {
    winopts = {
      height = .3,
      width = 1,
      row = 1,
      preview = { default = 'bat' },
    },
  },
}

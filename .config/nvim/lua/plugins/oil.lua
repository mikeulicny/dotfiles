return {
  'stevearc/oil.nvim',
  dependencies = {
      'nvim-tree/nvim-web-devicons'
  },
  keys = {
      {"-", "<CMD>Oil --float<CR>", desc = "Open parent directory" }
  },
  opts = {
    watch_for_changes = true,
    show_hidden = true,
    float = {
      max_width = 150,
      max_height = 40,
    },
  },
}

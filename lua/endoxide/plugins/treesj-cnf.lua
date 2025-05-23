return {
  'Wansmer/treesj',
  enabled = false,
  keys = { '<space>m', '<space>j', '<space>s' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- if you install parsers with `nvim-treesitter`
  config = function()
    local treesj = require('treesj')
    treesj.setup()
  end,
}

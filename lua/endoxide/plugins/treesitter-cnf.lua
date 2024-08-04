return {
  "nvim-treesitter/nvim-treesitter", -- TreeSitter
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-refactor",
  },
  config = function()
    local ts = require("nvim-treesitter.configs")

    local configs = {
      ensure_installed = "all",
      sync_install = false,
      ignore_install = { "" },        -- List of parsers to ignore installing
      highlight = {
        enable = true,                -- false will disable the whole extension
        disable = { "latex", "lua" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = true,
      },
      refactor = {
        highlight_definitions = {
          enable = true,
          clear_on_cursor_move = false,
        },
      }
    }

    ts.setup(configs)
  end
}

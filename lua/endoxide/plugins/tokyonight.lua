return {
  "folke/tokyonight.nvim",
  lazy = false,      -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,   -- make sure to load this before all the other start plugins
  config = function()
    local tokyonight = require("tokyonight")

    local config = {
        style = "moon",
        transparent = true,
        styles = {
            sidebars = "transparent",
            floats = "transparent",
        }
    }

    tokyonight.setup(config)

    vim.cmd([[colorscheme tokyonight-night]])
    require("endoxide.colors").ColorMyPencils()
  end
}

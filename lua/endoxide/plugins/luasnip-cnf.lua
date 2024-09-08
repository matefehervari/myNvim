return {
  "L4MON4D3/LuaSnip",
  dependencies = { "rafamadriz/friendly-snippets" },
  event = "VeryLazy",
  config = function()
    local ls = require("luasnip")
    local vscode = require("luasnip.loaders.from_vscode")
    local lua = require("luasnip.loaders.from_lua")


    ls.config.setup({
      enable_autosnippets = true
    })

    lua.load({
      paths = "./lua/endoxide/snippets",
    })
    -- vscode.lazy_load {
    --   exclude = { "tex" }
    -- }
  end
}

return {
  "L4MON4D3/LuaSnip",
  event = "VeryLazy",
  config = function()
    local ls = require("luasnip")
    local vscode = require("luasnip.loaders.from_vscode")
    local lua = require("luasnip.loaders.from_lua")

    vscode.load {
      exclude = { "tex" }
    }

    ls.config.setup({
      enable_autosnippets = true
    })

    lua.lazy_load({ paths = "./lua/endoxide/snippets" })
  end
}

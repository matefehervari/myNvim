local configs = require("nvim-treesitter.configs")
-- local spellsitter = require("spellsitter")

configs.setup {
  ensure_installed = "all",
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "latex" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  context_commentstring = {
    enable =true,
  },
  autotag = {
      enable = true,
  },
}

-- spellsitter.setup()

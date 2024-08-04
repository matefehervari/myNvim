return {
  "ggandor/leap.nvim",
  config = function ()
    local k = require("endoxide.keymap")
    local nnoremap = k.nnoremap

    -- leap.create_default_mappings()
    nnoremap("<leader>s", "<Plug>(leap-forward)")
    nnoremap("<leader>S", "<Plug>(leap-backward)")
    nnoremap("gs", "<Plug>(leap-from-window)")
  end
}

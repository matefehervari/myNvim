local Remap = require("endoxide.keymap")
local nnoremap = Remap.nnoremap

nnoremap("gf", function() -- format file
  vim.lsp.buf.format()
end)

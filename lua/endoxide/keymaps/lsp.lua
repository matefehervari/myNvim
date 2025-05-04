local Remap = require("endoxide.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

nnoremap("gf", function() -- format file
  vim.lsp.buf.format()
end)

vnoremap("gf", function() -- format file
  vim.lsp.buf.format()
end)

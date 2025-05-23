local Remap = require("endoxide.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

nnoremap("gf", function() -- format file
  vim.lsp.buf.format()
end, {desc="LSP format buffer"})

vnoremap("gf", function() -- format file
  vim.lsp.buf.format()
end, {desc="LSP format lines"})

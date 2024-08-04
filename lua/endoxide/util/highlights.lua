local M = {}

M.hl = function(thing, opts)
  vim.api.nvim_set_hl(0, thing, opts)
end

return M

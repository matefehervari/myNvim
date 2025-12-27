local M = {}

--- Sets a highlight group
--- @param thing string
--- @param opts vim.api.keyset.highlight
M.hl = function(thing, opts)
    vim.api.nvim_set_hl(0, thing, opts)
end

M.hl_text = function(highlight, text)
    return ("%%#%s#%s%%#Normal#"):format(highlight, text)
end

M.gethl = function(highlight)
    return vim.api.nvim_get_hl(0, { name = highlight })
end

M.getfg = function(highlight)
    return vim.api.nvim_get_hl(0, { name = highlight }).fg
end

M.getbg = function(highlight)
    return vim.api.nvim_get_hl(0, { name = highlight }).bg
end

return M

local buffers = {}
local bufferspinned = {}

local endoxide = {
    buffers = buffers,
    bufferspinned = bufferspinned,
}

if vim.g.endoxide == nil then
    vim.g.endoxide = endoxide
end

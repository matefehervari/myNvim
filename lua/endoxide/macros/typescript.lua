local autocommand = require("endoxide.autocommand")
local autocmd = autocommand.autocmd
local group = autocommand.endoxideGroup

autocmd({ "BufNew", }, {
    group = group,
    pattern = "*.tsx",
    callback = function()
        vim.fn.setreg("s","vatof>i class={}i")
    end
})

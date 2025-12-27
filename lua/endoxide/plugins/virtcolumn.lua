return {
    "xiyaowong/virtcolumn.nvim",
    config = function()
        local hl = require("endoxide.util.highlights").hl
        hl("VirtColumn", {
            link = "Special",
        })
    end
}

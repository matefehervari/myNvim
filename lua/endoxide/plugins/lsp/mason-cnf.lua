return {
    "williamboman/mason.nvim",
    config = function ()
        local mason = require("mason")
        local config = {
            ui = {
                border = "rounded"
            }
        }
        mason.setup(config)
    end
}

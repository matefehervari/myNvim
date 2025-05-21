return {
    "williamboman/mason.nvim",
    config = function ()
        local mason = require("mason")
        local nnoremap = require("endoxide.keymap").nnoremap
        local config = {
            ui = {
                border = "rounded"
            }
        }
        mason.setup(config)

        nnoremap("<leader>fm", "<Cmd>Mason<CR>", {desc = "Open Mason"})
    end
}

return {
    "olimorris/persisted.nvim", -- sessions
    lazy = false,
    config = function()
        local persisted = require("persisted")
        local nnoremap = require("endoxide.keymap").nnoremap

        persisted.setup()

        -- keymaps
        nnoremap("<leader>qs", function() persisted.load() end, { desc = "Restore session for the current directory"})
        nnoremap("<leader>ql", function() persisted.load({ last = true }) end, { desc = "Restore the last session" })
        nnoremap("<leader>qd", function() persisted.stop() end,
            { desc = "Stop persistance. Session will not be saved on exit" })
    end
}

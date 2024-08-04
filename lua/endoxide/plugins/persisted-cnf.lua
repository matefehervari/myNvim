return {
  "olimorris/persisted.nvim", -- sessions
  lazy = false,
  config = function()
    local persisted = require("persisted")
    local nnoremap = require("endoxide.keymap").nnoremap

    persisted.setup()

    -- keymaps
    nnoremap("<leader>qs", function() persisted.load() end)                -- restore the session for the current directory
    nnoremap("<leader>ql", function() persisted.load({ last = true }) end) -- restore the last session
    nnoremap("<leader>qd", function() persisted.stop() end)                -- stop Persistence => session won't be saved on exit
  end
}

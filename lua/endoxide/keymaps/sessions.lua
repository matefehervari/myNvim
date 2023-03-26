local Remap = require("endoxide.keymap")
local nnoremap = Remap.nnoremap

-- restore the session for the current directory
nnoremap("<leader>qs", [[<cmd>lua require("persistence").load()<cr>]])

-- restore the last session
nnoremap("<leader>ql", [[<cmd>lua require("persistence").load({ last = true })<cr>]])

-- stop Persistence => session won't be saved on exit
nnoremap("<leader>qd", [[<cmd>lua require("persistence").stop()<cr>]])

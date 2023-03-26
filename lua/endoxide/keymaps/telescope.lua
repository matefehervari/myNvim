local Remap = require("endoxide.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<C-p>", ":Telescope<CR>")
nnoremap("<leader>ff", function()
    require("telescope.builtin").find_files()
end)
nnoremap("<leader>fd", ":Telescope find_files cwd=")
-- search for string
nnoremap("<leader>fs", function()
    require("telescope.builtin").live_grep()
end)
-- search for currently hovered word
nnoremap("<leader>fw", function()
    require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") })
end)
-- search through sessions
nnoremap("<leader>fq", ":Telescope persisted<CR>")
-- TODO: file search

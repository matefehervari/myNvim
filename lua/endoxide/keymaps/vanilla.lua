local Remap = require("endoxide.keymap")

local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local cnoremap = Remap.cnoremap
local tnoremap = Remap.tnoremap
local snoremap = Remap.snoremap

nnoremap("<space>", "<Nop>")


-- enter insert mode 2 lines above or below
nnoremap("<leader>O", "O<ESC>O")
nnoremap("<leader>o", "o<ESC>o")
nnoremap("<A-o>", "moo<ESC>`o")
nnoremap("<A-O>", "moO<ESC>`o")
inoremap("<A-o>", "_<ESC>moo<ESC>`os")
inoremap("<A-O>", "_<ESC>moO<ESC>`os")

-- quick writing
nnoremap("<leader>w", ":wa<CR>")

-- moving between splits
nnoremap("<C-j>", "<C-w>j")
nnoremap("<C-k>", "<C-w>k")
nnoremap("<C-h>", "<C-w>h")
nnoremap("<C-l>", "<C-w>l")

-- moving from terminal split
tnoremap("<C-k>", [[<C-\><C-n><C-w>k]])
tnoremap("<C-j>", [[<C-\><C-n><C-w>j]])
tnoremap("<C-h>", [[<C-\><C-n><C-w>h]])
tnoremap("<C-l>", [[<C-\><C-n><C-w>l]])

-- navigation in command mode
cnoremap("<C-h>", "<Left>")
cnoremap("<C-l>", "<Right>")

-- navigation in insert mode
inoremap("<C-h>", "<Left>")
inoremap("<C-l>", "<Right>")

-- escape is a bit of a stetch
-- clears luasnip jumpable
inoremap("<S-Tab>", [[<ESC>:lua require('luasnip').unlink_current()<CR>:lua print(' ')<CR>]])
vnoremap("<S-Tab>", "<ESC>")
snoremap("<S-Tab>", [[<ESC>:lua require('luasnip').unlink_current()<CR>:lua print(' ')<CR>]])
cnoremap("<S-Tab>", "<C-c>")
tnoremap("<S-Tab>", [[<C-\><C-n>]])

-- move lines around
-- nnoremap("<C-n>", ":m .-2<CR>==")
-- nnoremap("<C-m>", ":m .+1<CR>==")
vnoremap("<C-h>", ":m '<-2<CR>gv")
vnoremap("<C-l>", ":m '>+1<CR>gv")

-- tab is superior
-- nnoremap("<Tab>", ">>")
-- nnoremap("<S-Tab>", "<<")
nnoremap(">", ">>")
nnoremap("<", "<<")
vnoremap(">", ">gv")
vnoremap("<", "<gv")

-- paste in place of visual block
xnoremap("<leader>p", [["_dP]])

-- replaces words currently hovered with keyword boundaries set
nnoremap("<leader>rr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- move half pages with recentre
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

nnoremap("<leader>cd", function()
    vim.cmd("lcd" .. vim.fn.expand("%:p:h"))
end)

-- visual bracketing
vnoremap("<leader>(", "s()<Esc><Left>p")
vnoremap("<leader>)", "s()<Esc><Left>p")
vnoremap("<leader>{", "s{}<Esc><Left>p")
vnoremap("<leader>}", "s{}<Esc><Left>p")
vnoremap("<leader>[", "s[]<Esc><Left>p")
vnoremap("<leader>]", "s[]<Esc><Left>p")
vnoremap("<leader><", "s<><Esc><Left>p")
vnoremap("<leader>>", "s<><Esc><Left>p")
vnoremap([[<leader>"]], [[s""<Esc><Left>p]])
vnoremap([[<leader>']], [[s''<Esc><Left>p]])
vnoremap([[<leader>`]], [[s``<Esc><Left>p]])

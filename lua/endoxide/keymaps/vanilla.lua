local Remap = require("endoxide.keymap")
local status_ok, luasnip = pcall(require, "luasnip")

local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap
local cnoremap = Remap.cnoremap
local tnoremap = Remap.tnoremap
local snoremap = Remap.snoremap
local nmap = Remap.nmap

local function remove_all_snips()
    while not luasnip.get_active_snip() do
      print("removing snippet: " .. luasnip.get_sctive_snip())
      luasnip.unlink_current()
    end
end

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
nnoremap("<Tab>", ">>")
nnoremap("<S-Tab>", "<<")
vnoremap(">", ">gv")
vnoremap("<", "<gv")
-- if status_ok then
--   snoremap("<S-Tab>", function ()
--     remove_all_snips()
--     vim.cmd([[call feedkeys("\<Esc>")]])
--   end) -- must be placed here as select also used normal and visual
-- end

snoremap("<C-g>", function ()
  print(vim.api.nvim_get_mode()["mode"])
end)

-- netrw
nnoremap("<leader>pv", ":Ex<CR>")

-- paste in place of visual block
xnoremap("<leader>p", [["_dP]])

-- replaces words currently hovered with keyword boundaries set
nnoremap("<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

-- move half pages with recentre
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- terminal creation
nnoremap("<leader>t", ":ToggleTerm<CR>")
nnoremap("<leader>T", ":ToggleTerm direction=tab<CR>")

nnoremap("<leader>cd", function()
    vim.cmd("lcd" .. vim.fn.expand("%:p:h"))
end)

-- tab navigation
nnoremap("<S-l>", ":bnext<CR>")
nnoremap("<S-h>", ":bprevious<CR>")
nnoremap("<C-q>", ":bdelete<CR>")

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

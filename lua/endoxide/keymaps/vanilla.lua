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
nnoremap("<leader>w", function()
    vim.cmd("silent! write")
end)

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

-- clears luasnip jumpable
inoremap("<ESC>", function()
    vim.cmd("stopinsert")
    local luasnip = require("luasnip")
    if luasnip.jumpable() then
        luasnip.unlink_current()
    end
end)
vnoremap("<ESC>", "<C-c>")
snoremap("<ESC>", function()
    vim.cmd("stopinsert")
    local luasnip = require("luasnip")
    if luasnip.jumpable() then
        luasnip.unlink_current()
    end
end)
tnoremap("<ESC>", [[<C-\><C-n>]])
cnoremap("<ESC>", "<C-c>")

-- move lines around
nnoremap("<C-Up>", ":m .-2<CR>==")
nnoremap("<C-Down>", ":m .+1<CR>==")
vnoremap("<C-Up>", ":m '<-2<CR>gv")
vnoremap("<C-Down>", ":m '>+1<CR>gv")

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

-- remove superfluous space
nnoremap("gds", [[:s/\S\zs\s\{2,}/ /g<CR>]])
vnoremap("gds", [[:s/\S\zs\s\{2,}/ /g<CR>]])

-- run program
nnoremap("<leader>rt", function()
    local file_name = vim.api.nvim_buf_get_name(0)
    local file_type = vim.bo.filetype

    if file_type == "python" then
        vim.cmd(":terminal python3 " .. file_name)
    elseif file_type == "sh" then
        vim.cmd(":terminal sh " .. file_name)
    elseif file_type == "bash" then
        vim.cmd(":terminal bash " .. file_name)
    elseif file_type == "c" then
        vim.cmd(":terminal gcc " .. file_name .. "; ./a.out")
    end
end)

-- execute and source
nnoremap("<leader><leader>x", "<cmd>source %<CR>")
nnoremap("<leader>x", "<cmd>.lua<CR>")
vnoremap("<leader>x", "<cmd>lua<CR>")

-- Custom user commmands
-- duplicate with replace
nnoremap("gyd", "<cmd>DuplicateWithReplace<CR>")
vnoremap("gyd", "<cmd>DuplicateWithReplace<CR>")

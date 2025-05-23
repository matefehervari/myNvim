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
nnoremap("<leader>O", "O<ESC>O", {desc="Insert and edit 2 lines above"})
nnoremap("<leader>o", "o<ESC>o", {desc="Insert and edit 2 lines below"})
nnoremap("<A-o>", "moo<ESC>`o", {desc="Insert new line below"})
nnoremap("<A-O>", "moO<ESC>`o", {desc="Insert new line above"})
inoremap("<A-o>", "_<ESC>moo<ESC>`os", {desc="Insert new line below"})
inoremap("<A-O>", "_<ESC>moO<ESC>`os", {desc="Insert new line above"})

-- quick writing
nnoremap("<leader>w", function()
    vim.cmd("silent! write")
end, {desc="Write buffer"})

nnoremap("<leader>aw", function()
    vim.cmd("silent! wa")
end, {desc="Write all buffers"})

-- moving between splits
nnoremap("<C-h>", "<C-w>h", {desc="Jump to left split"})
nnoremap("<C-j>", "<C-w>j", {desc="Jump to below split"})
nnoremap("<C-k>", "<C-w>k", {desc="Jump to above split"})
nnoremap("<C-l>", "<C-w>l", {desc="Jump to right split"})

-- moving from terminal split
tnoremap("<C-h>", [[<C-\><C-n><C-w>h]], {desc="Jump to left split"})
tnoremap("<C-j>", [[<C-\><C-n><C-w>j]], {desc="Jump to below split"})
tnoremap("<C-k>", [[<C-\><C-n><C-w>k]], {desc="Jump to above split"})
tnoremap("<C-l>", [[<C-\><C-n><C-w>l]], {desc="Jump to right split"})

-- navigation in command mode
cnoremap("<C-h>", "<Left>", {desc="Move left in command"})
cnoremap("<C-l>", "<Right>", {desc="Move right in command"})

-- navigation in insert mode
inoremap("<C-h>", "<Left>", {desc="Move left in insert"})
inoremap("<C-l>", "<Right>", {desc="Move right in insert"})

-- clears luasnip jumpable
inoremap("<ESC>", function()
    vim.cmd("stopinsert")
    local luasnip = require("luasnip")
    if luasnip.jumpable() then
        luasnip.unlink_current()
    end
end, {desc="Stop insert mode (unlink snippet jumps)"})
vnoremap("<ESC>", "<C-c>", {desc="Stop visual mode"})
snoremap("<ESC>", function()
    vim.cmd("stopinsert")
    local luasnip = require("luasnip")
    if luasnip.jumpable() then
        luasnip.unlink_current()
    end
end, {desc="Stop replace mode (unlink snippet jumps)"})
tnoremap("<ESC>", [[<C-\><C-n>]], {desc="Stop terminal mode"})
cnoremap("<ESC>", "<C-c>", {desc="Stop command mode"})
nnoremap("<ESC>", function ()
    local buf_ft = vim.api.nvim_get_option_value("filetype", {})
    if buf_ft == "checkhealth" then
        vim.cmd("tabclose")
    end
end, {desc = "Normal mode escape actions"})

-- move lines around
nnoremap("<C-Up>", ":m .-2<CR>==", {desc="Move line up"})
nnoremap("<C-Down>", ":m .+1<CR>==", {desc="Move line down"})
vnoremap("<C-Up>", ":m '<-2<CR>gv", {desc="Move lines up"})
vnoremap("<C-Down>", ":m '>+1<CR>gv", {desc="Move lines down"})

-- indentation
nnoremap(">", ">>", {desc="Indent line"})
nnoremap("<", "<<", {desc="Unindent line"})
vnoremap(">", ">gv", {desc="Indent lines"})
vnoremap("<", "<gv", {desc="Unindent lines"})

-- paste in place of visual block
xnoremap("<leader>p", [["_dP]], {desc="Past visual block (no clobber)"})

-- replaces words currently hovered with keyword boundaries set
nnoremap("<leader>rr", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", {desc="Replace all words in buffer"})

-- move half pages with recentre
nnoremap("<C-d>", "<C-d>zz", {desc="Jump down half screen"})
nnoremap("<C-u>", "<C-u>zz", {desc="Jump up half screen"})

nnoremap("<leader>cd", function()
    vim.cmd("lcd" .. vim.fn.expand("%:p:h"))
end, {desc="Update working directory to buffer"})

-- visual bracketing
vnoremap("<leader>(", "s()<Esc><Left>p", {desc="Surround ()"})
vnoremap("<leader>)", "s()<Esc><Left>p", {desc="Surround ()"})
vnoremap("<leader>{", "s{}<Esc><Left>p", {desc="Surround {}"})
vnoremap("<leader>}", "s{}<Esc><Left>p", {desc="Surround {}"})
vnoremap("<leader>[", "s[]<Esc><Left>p", {desc="Surround []"})
vnoremap("<leader>]", "s[]<Esc><Left>p", {desc="Surround []"})
vnoremap("<leader><", "s<><Esc><Left>p", {desc="Surround <>"})
vnoremap("<leader>>", "s<><Esc><Left>p", {desc="Surround <>"})
vnoremap([[<leader>"]], [[s""<Esc><Left>p]], {desc=[[Surround ""]]})
vnoremap([[<leader>']], [[s''<Esc><Left>p]], {desc="Surround ''"})
vnoremap([[<leader>`]], [[s``<Esc><Left>p]], {desc="Surround ``"})

-- remove superfluous space
nnoremap("gds", [[:s/\S\zs\s\{2,}/ /g<CR>]], {desc="Remove superfluous spaces"})
vnoremap("gds", [[:s/\S\zs\s\{2,}/ /g<CR>gv]], {desc="Remove superfluous spaces"})

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
end, {desc="Run in terminal"})

-- execute and source
nnoremap("<leader><leader>x", "<cmd>source %<CR>", {desc="Source file"})
nnoremap("<leader>x", "<cmd>.lua<CR>", {desc="Run line in Lua"})
vnoremap("<leader>x", "<cmd>lua<CR>", {desc="Run lines in Lua"})

-- Custom user commmands
-- duplicate with replace
nnoremap("gdr", "<cmd>DuplicateWithReplace<CR>", {desc="DuplicateWithReplace"})
vnoremap("gdr", "<cmd>DuplicateWithReplace<CR>", {desc="DuplicateWithReplace lines"})

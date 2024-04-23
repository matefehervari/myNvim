vim.cmd([[
    augroup endoxide
        autocmd BufRead * lcd %:p:h
    augroup end
]])

local augroup = vim.api.nvim_create_augroup
endoxideGroup = augroup('endoxide', {})

local autocmd = vim.api.nvim_create_autocmd

-- autocmd({"InsertLeave"}, {
--     group = endoxideGroup,
--     pattern = "*",
--     callback = function()
--         print(vim.api.nvim_get_mode()["mode"])
--         if vim.api.nvim_get_mode()["mode"] == "n" then
--           print("reset luasnip")
--           require("luasnip").unlink_current()
--         end
--     end
-- })

-- latex spell checking
autocmd({"BufRead"}, {
  group = endoxideGroup,
  pattern = "*.tex",
  callback = function ()
    vim.cmd(":setlocal spell spelllang=en")
  end
})

-- workaround for un/core handle error message
autocmd({ "VimLeave" }, {
  callback = function()
    vim.fn.jobstart('notify-send ""', {detach=true})
  end,
})

autocmd({"BufRead"}, {
  group = endoxideGroup,
  pattern = "*.pro",
  callback = function()
    vim.cmd(":set filetype=prolog")
  end,
})

-- open personal latex 
-- autocmd({"BufRead"}, {
--   group = endoxideGroup,
--   pattern = "*.tex",
--   callback = function ()
--     print("tex detected")
--     if vim.fn.expand("%:p") ~= vim.fn.expand("$PERSONAL_TEX") then
--       print("opening personal")
--       vim.cmd(":arg " .. vim.fn.expand("$PERSONAL_TEX"))
--     end
--   end
-- })

-- vim.cmd([[ 
--   autocmd BufWritePost work.tex :VimtexCompile
-- ]])

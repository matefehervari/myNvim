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

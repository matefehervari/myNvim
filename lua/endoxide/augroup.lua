vim.cmd([[
    augroup endoxide
        autocmd BufRead * lcd %:p:h
    augroup end
]])

local augroup = vim.api.nvim_create_augroup
local endoxideGroup = augroup('endoxide', {})

local autocmd = vim.api.nvim_create_autocmd

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

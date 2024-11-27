local tsutils = require("endoxide.util.tsutils")

vim.cmd([[
    augroup endoxide
        autocmd BufRead * lcd %:p:h
    augroup end
]])

local augroup = vim.api.nvim_create_augroup
local endoxideGroup = augroup('endoxide', {})

local autocmd = vim.api.nvim_create_autocmd

-- latex spell checking
autocmd({ "BufRead" }, {
  group = endoxideGroup,
  pattern = "*.tex",
  callback = function()
    vim.cmd(":setlocal spell spelllang=en")
  end
})

-- latex math zone detection
autocmd({ "CursorMoved", "CursorMovedI" }, {
  group = endoxideGroup,
  pattern = "*.tex",
  callback = function()
    vim.g.prev_tex_in_math_zone = vim.g.tex_in_math_zone
    vim.g.tex_in_math_zone = tsutils.in_mathzone()
  end
})

-- workaround for un/core handle error message
autocmd({ "VimLeave" }, {
  callback = function()
    vim.fn.jobstart('notify-send ""', { detach = true })
  end,
})

autocmd({ "BufRead" }, {
  group = endoxideGroup,
  pattern = "*.pro",
  callback = function()
    vim.cmd(":set filetype=prolog")
  end,
})

autocmd({ "BufRead" }, {
  group = endoxideGroup,
  pattern = "*.rasi",
  callback = function()
    vim.cmd(":set filetype=rasi")
  end,
})

autocmd({ "BufRead" }, {
  group = endoxideGroup,
  pattern = "*.bsv",
  callback = function()
    vim.cmd(":set commentstring=//%s")
  end,
})

autocmd("LspAttach", {
  group = endoxideGroup,
  callback = function()
    vim.lsp.inlay_hint.enable()
  end
})

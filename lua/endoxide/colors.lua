local hl = require("endoxide.util.highlights").hl

local colors = {
    black = "#000000"
}

local function ColorMyPencils()
  vim.g.tokyonight_transparent_sidebar = true
  vim.g.tokyonight_transparent = true
  vim.opt.background = "dark"

  hl("SignColumn", {
    bg = "none",
  })

  hl("ColorColumn", {
    ctermbg = 0,
    bg = "#343d59",
  })

  hl("VirtualColumn", {
    fg = "#111111"
  })

  hl("CursorLineNR", {
    bg = "None"
  })

  hl("Normal", {
    bg = "none"
  })

  hl("NormalNC", {
    bg = "none"
  })

  hl("NvimTreeNormal", {
    bg = "none"
  })

  hl("LineNr", {
    fg = "#5eacd3"
  })

  hl("NvimTreeWinSeparator", {
    bg = "none"
  })

  hl("NvimTreeNormalNC", {
    bg = "none"
  })

  hl("BufferLineDevIconDefaultSelected", {
    bg = "none"
  })

  hl("BufferLineDevIconLuaSelected", {
    bg = "none"
  })

  hl("Pmenu", {
    bg = "None"
  })

  hl("NormalFloat", {
    bg = "None"
  })

  hl("FloatBorder", {
    bg = "None"
  })

  hl("LspInlayHint", {
    fg = "#545c7e",
    bg = "none",
  })

  hl("StatusLine", {
    bg = "None"
  })
  hl("StatusLineNC", {
    bg = "None"
  })
end

local M = {}
M.ColorMyPencils = ColorMyPencils
M.colors = colors

return M

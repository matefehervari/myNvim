vim.g.endoxide_colorscheme = "tokyonight"

local hl = require("endoxide.util.highlights").hl

function ColorMyPencils()
  -- vim.g.gruvbox_contrast_dark = 'hard'
  vim.g.tokyonight_transparent_sidebar = true
  vim.g.tokyonight_transparent = true
  -- vim.g.gruvbox_invert_selection = '0'
  vim.opt.background = "dark"

  vim.cmd("colorscheme " .. vim.g.endoxide_colorscheme)

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
end

ColorMyPencils()

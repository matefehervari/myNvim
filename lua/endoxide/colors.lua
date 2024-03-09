vim.g.endoxide_colorscheme = "tokyonight"

function ColorMyPencils()
  -- vim.g.gruvbox_contrast_dark = 'hard'
  vim.g.tokyonight_transparent_sidebar = true
  vim.g.tokyonight_transparent = true
  -- vim.g.gruvbox_invert_selection = '0'
  vim.opt.background = "dark"

  local status_ok, _ = pcall(vim.cmd, "colorscheme " .. vim.g.endoxide_colorscheme)
  if not status_ok then
    print("colorscheme" .. vim.g.endoxide_colorscheme .. "not found!")
    return
  end

  local hl = function(thing, opts)
    vim.api.nvim_set_hl(0, thing, opts)
  end

  hl("SignColumn", {
    bg = "none",
  })

  hl("ColorColumn", {
    ctermbg = 0,
    bg = "#343d59",
  })

  hl("VirtualColumn", {
    fg="#111111"
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

end

ColorMyPencils()

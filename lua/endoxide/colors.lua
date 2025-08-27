local highlights = require("endoxide.util.highlights")
local hl = highlights.hl
local fg = highlights.getfg
local bg = highlights.getbg

local colors = {
    black = "#000000",
    white = "#ffffff",
    error_inactive = "#880000",
    error = "#cc0000",
    warning_inactive = "#b37400",
    warning = "#ffa500",
    hint_inactive = "#888888",
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

    hl("CursorLine", {
        fg = fg("Special"),
        bg = bg("Normal"),
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

    hl("Pmenu", {
        bg = "None"
    })

    hl("NormalFloat", {
        bg = "None"
    })

    hl("FloatBorder", {
        fg = fg("Special"),
        bg = "None"
    })

    hl("LspInlayHint", {
        fg = "#545c7e",
        bg = "none",
    })

    hl("StatusLine", {
        fg = fg("Special"),
        -- bg = fg("Special"),
        bg = "None"
    })
    hl("StatusLineNC", {
        fg = fg("Special"),
        bg = fg("Special"),
    })

    hl("DiagnosticVirtualTextError", {
        fg = fg("DiagnosticError"),
        bg = bg("Normal"),
    })

    hl("DiagnosticVirtualTextWarn", {
        fg = fg("DiagnosticWarn"),
        bg = bg("Normal"),
    })

    hl("DiagnosticVirtualTextHint", {
        fg = fg("DiagnosticHint"),
        bg = bg("Normal"),
    })

    hl("EndoxideBuffer", {
        fg = fg("TabLine"),
        bg = bg("Normal")
    })

    hl("EndoxideBufferSelected", {
        fg = colors.white,
        bg = bg("Normal"),
        bold = true
    })

    hl("EndoxideError", {
        fg = colors.error_inactive,
        bg = bg("Normal"),
    })

    hl("EndoxideErrorSelected", {
        fg = fg("DiagnosticError"),
        bg = bg("Normal"),
        bold = true
    })

    hl("EndoxideWarning", {
        fg = colors.warning_inactive,
        bg = bg("Normal"),
    })

    hl("EndoxideWarningSelected", {
        fg = fg("DiagnosticWarn"),
        bg = bg("Normal"),
        bold = true
    })

    hl("EndoxideHint", {
        fg = colors.hint_inactive,
        bg = bg("Normal"),
    })

    hl("EndoxideHintSelected", {
        fg = fg("DiagnosticHint"),
        bg = bg("Normal"),
        bold = true,
    })

    hl("EndoxideLspConnected", {
        fg = "#32a852",
        bg = bg("Normal"),
    })

    hl("EndoxideLspDisconnected", {
        fg = fg("TabLine"),
        bg = bg("Normal"),
    })


    hl("WinSeparator", {
        fg = fg("Special"),
        bg = bg("Special"),
        -- bold = true,
    })

    hl("VertSplit", {
        fg = fg("Special"),
        bg = bg("Special"),
        -- bold = true,
    })
end


local M = {}
M.ColorMyPencils = ColorMyPencils
M.colors = colors

return M

return {
  "akinsho/bufferline.nvim",
  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },

  config = function()
    local bufferline = require("bufferline")

    local icons = require("endoxide.icons")
    local ui = icons.ui
    local diagnostics = icons.diagnostics

    local config = {
      options = {
        numbers = "none",              -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
        close_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
        indicator = {
          -- icon = "▎",
          icon = "",
          style = "icon"
        },
        hover = {
          enabled = true,
          delay = 0,
          reveal = { 'close' }
        },
        buffer_close_icon = ui.Close,
        modified_icon = ui.Circle,
        close_icon = ui.Close,
        left_trunc_marker = ui.ArrowCircleLeft,
        right_trunc_marker = ui.ArrowCircleRight,
        max_name_length = 30,
        max_prefix_length = 30,   -- prefix used when a buffer is de-duplicated
        tab_size = 21,
        diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc",
        diagnostics_update_in_insert = true,
        diagnostics_indicator = function(count, level)
          local icon = (level:match("error") and diagnostics.Error) or
              (level:match("warning") and diagnostics.Warning) or
              diagnostics.Information
          return " " .. icon .. count
        end,
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            padding = 0,
          }
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
        -- can also be a table containing 2 custom separators
        -- [focused and unfocused]. eg: { '|', '|' }
        separator_style = { "", "" }, -- | "thick" | "thin" | { 'any', 'any' },
        enforce_regular_tabs = true,
        always_show_bufferline = true,

        custom_filter = (function(buf_number, _) -- buf_number, buf_numbers
          -- filter out filetypes you don't want to see
          if vim.bo[buf_number].filetype == "dap-repl" then
            return false
          end
          return true
        end),
      },
      highlights = {
        fill = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        background = {
          fg = "#888888", -- { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        buffer_visible = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        close_button = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        close_button_visible = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        tab_selected = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        tab = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        tab_close = {
          -- fg = {attribute='fg',highlight='LspDiagnosticsDefaultError'},
          fg = { attribute = "fg", highlight = "TabLineSel" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        duplicate_selected = {
          fg = { attribute = "fg", highlight = "TabLineSel" },
          bg = { attribute = "bg", highlight = "TabLineSel" },
          italic = true,
        },

        duplicate_visible = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "TabLine" },
          italic = true,
        },

        duplicate = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "TabLine" },
          italic = true,
        },

        modified = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        modified_selected = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        modified_visible = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "TabLine" },
        },

        separator = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        separator_selected = {
          fg = { attribute = "fg", highlight = "TabLine" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        indicator_selected = {
          fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
          bg = { attribute = "bg", highlight = "Normal" },
        },

        error = {
          fg = "#880000",
          bg = { attribute = "bg", highlight = "BufferLineError" }
        },

        error_diagnostic = {
          fg = "#880000",
          bg = { attribute = "bg", highlight = "BufferLineErrorDiagnostic" }
        },

        error_diagnostic_selected = {
          fg = "#ff0000",
          bg = { attribute = "bg", highlight = "BufferLineErrorSelected" },
          sp = "#ff0000"
        },


        warning = {
          fg = "#b37400",
          bg = { attribute = "bg", highlight = "BufferLineWarning" }
        },

        warning_diagnostic = {
          fg = "#b37400",
          bg = { attribute = "bg", highlight = "BufferLineWarningDiagnostic" }
        },

        warning_diagnostic_selected = {
          fg = "#ffa500",
          bg = { attribute = "bg", highlight = "BufferLineWarningSelected" },
          sp = "#ff0000"
        },


        hint = {
          fg = "#888888",
          bg = { attribute = "bg", highlight = "BufferLineHint" }
        },

        hint_diagnostic = {
          fg = "#888888",
          bg = { attribute = "bg", highlight = "BufferLineHintDiagnostic" }
        },

        hint_diagnostic_selected = {
          fg = { attribute = "fg", highlight = "Normal" },
          bg = { attribute = "bg", highlight = "Normal" },
          sp = { attribute = "sp", highlight = "Normal" }
        },
      },
    }

    bufferline.setup(config)

    -- highlight icons
    local autocmd = vim.api.nvim_create_autocmd

    local hl = function(thing, opts)
      vim.api.nvim_set_hl(0, thing, opts)
    end

    autocmd({ "BufRead", "BufEnter" }, {

      callback = function()
        local webdevicon = require("nvim-web-devicons")

        local filename = vim.fn.expand("%:t")
        local ext = vim.fn.expand("%:e")
        local _, icon_name = webdevicon.get_icon(filename, ext, { default = true })
        local _, icon_color = webdevicon.get_icon_color(filename, ext, { default = true })
        if not icon_name then
          return
        end

        hl("BufferLine" .. icon_name, { bg = "none", fg = icon_color })
        hl("BufferLine" .. icon_name .. "Selected", { bg = "none", fg = icon_color })
        hl("BufferLine" .. icon_name .. "Inactive", { bg = "none", fg = icon_color })
      end
    })

    -- keymaps
    local nnoremap = require("endoxide.keymap").nnoremap
    nnoremap("<S-l>", ":bnext<CR>")
    nnoremap("<S-h>", ":bprevious<CR>")
    nnoremap("<C-q>", ":bdelete<CR>")
  end
}

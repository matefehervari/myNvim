return {
  "nvim-lualine/lualine.nvim", -- lualine
  config = function()
    local lualine = require("lualine")

    local branch = {
      "branch",
      icons_enabled = true,
      icon = "",
    }

    local mode = {
      "mode",
      fmt = function(str)
        return "-- " .. str .. " --"
      end
    }

    local filetype = {
      "filetype",
      icons_enabled = true,
    }

    -- cool function for progress
    local progress = function()
      local current_line = vim.fn.line(".")
      local total_lines = vim.fn.line("$")
      local chars = { " ", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
      local line_ratio = current_line / total_lines
      local index = math.ceil(line_ratio * #chars)
      return chars[index]
    end

    local config = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = ''},
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          "NvimTree",
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { branch },
        lualine_b = { mode },
        lualine_c = {},
        lualine_x = { 'encoding', filetype },
        lualine_y = { "location" },
        lualine_z = { progress }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {}
    }

    lualine.setup(config)
  end
}

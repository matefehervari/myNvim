-- local nnoremap = require("endoxide.keymap").nnoremap
--
-- local on_attach = function(bufnr)
--   local api = require('nvim-tree.api')
--
--   local function opts(desc)
--     return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
--   end
--
--   nnoremap('l', api.node.open.edit, opts('Open'))
--   nnoremap('<CR>', api.node.open.edit, opts('Open'))
--   nnoremap('h', api.node.navigate.parent_close, opts('Close Directory'))
--   nnoremap('v', api.node.open.vertical, opts('Open: Vertical Split'))
-- end

local on_attach = require("endoxide.nvim-tree-on-attach")

return {
  "kyazdani42/nvim-tree.lua",

  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },

  config = function()
    local nvim_tree = require("nvim-tree")

    -- local on_attach = require("endoxide.nvim-tree-on-attach")

    local config = {
      on_attach = on_attach,
      disable_netrw = true,
      hijack_netrw = true,
      hijack_cursor = false,
      sync_root_with_cwd = true,
      diagnostics = {
        enable = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      update_focused_file = {
        enable = true,
        update_root = true,
        ignore_list = {},
      },
      view = {
        width = 30,
        side = "left",
        adaptive_size = true,
        number = true,
        relativenumber = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = true,
        },
      },
      renderer = {
        root_folder_modifier = ":t",
      },
    }

    nvim_tree.setup(config)
  end
}

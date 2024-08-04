return {
  "kyazdani42/nvim-tree.lua",

  dependencies = {
    "kyazdani42/nvim-web-devicons",
  },

  config = function()
    local nvim_tree = require("nvim-tree")
    local api = require("nvim-tree.api")
    local on_attach = require("endoxide.util.nvim-tree-on-attach")

    local nnoremap = require("endoxide.keymap").nnoremap

    -- keymaps
    nnoremap("<leader>e", function ()
      api.tree.toggle()
    end)

    -- config
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
      system_open = {
        cmd = "sioyek"
      },
      git = {
        enable = true,
        ignore = false,
        timeout = 500,
      }
    }

    nvim_tree.setup(config)
  end
}

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  print("Failed to load nvim-tree")
  return
end

local on_attach_status_ok, on_attach = pcall(require, "endoxide.nvim-tree-on-attach")
if not on_attach_status_ok then
  print("Failed to load nvim-tree on attach")
  return
end

nvim_tree.setup {
  on_attach = on_attach,
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = false,
  sync_root_with_cwd = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
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
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    width = 30,
    -- height = 30,
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

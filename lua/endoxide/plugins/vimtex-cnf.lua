return {
  "lervag/vimtex", -- Latex
  config = function()
    vim.g.vimtex_view_method = "sioyek"

    vim.g.vimtex_callback_progpath = "/usr/bin/nvim"

    vim.g.vimtex_compiler_method = "tectonic"
    vim.g.vimtex_quickfix_open_on_warning = 0
    vim.g.vimtex_imaps_enabled = 0
    vim.g.vimtex_mappings_disable = {i = {"]]"}}
  end
}

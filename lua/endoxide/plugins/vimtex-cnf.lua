return {
  "lervag/vimtex", -- Latex
  config = function()
    vim.g.vimtex_view_method = "sioyek"

    vim.g.vimtex_compiler_method = "tectonic"
    vim.g.vimtex_quickfix_open_on_warning = 1
  end
}

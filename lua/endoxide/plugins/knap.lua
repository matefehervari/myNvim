return {
  "frabjous/knap",
  config = function ()
    local map = require("endoxide.keymap")
    local nnoremap = map.nnoremap

    nnoremap("<F5>", function () require("knap").process_once() end)
    nnoremap("<F6>", function () require("knap").close_viewer() end)
    nnoremap("<F7>", function () require("knap").toggle_autopreviewing() end)
    nnoremap("<F8>", function () require("knap").forward_jump() end)

    local config = {
      texoutputext = "pdf",
      textopdf = "tectonic --synctex %docroot%",
    }

    vim.g.knap_settings = config
  end
}

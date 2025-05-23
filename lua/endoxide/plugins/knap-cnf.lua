return {
  "frabjous/knap",
  config = function ()
    local map = require("endoxide.keymap")
    local nnoremap = map.nnoremap

    nnoremap("<F5>", function () require("knap").process_once() end, {desc="Knap process once"})
    nnoremap("<F6>", function () require("knap").close_viewer() end, {desc="Knap close viewer"})
    nnoremap("<F7>", function () require("knap").toggle_autopreviewing() end, {desc="Knap auto-previewing"})
    nnoremap("<F8>", function () require("knap").forward_jump() end, {desc="Knap forward jump"})

    local config = {
      texoutputext = "pdf",
      textopdf = "tectonic --synctex %docroot%",
      delay = 50,
    }

    vim.g.knap_settings = config
  end
}

local rt_status_ok, rt = pcall(require, "rust-tools")
if not rt_status_ok then
  return
end

rt.setup({
  server = {
    on_attach = require("endoxide.lsp.lsp-setup").on_attach
  }
})

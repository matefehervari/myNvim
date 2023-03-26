local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("endoxide.lsp.lsp-installer")
require("endoxide.lsp.handlers").setup()
require("endoxide.lsp.null-ls")

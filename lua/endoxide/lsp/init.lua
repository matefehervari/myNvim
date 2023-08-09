local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("endoxide.lsp.mason")
require("endoxide.lsp.lsp-setup").setup()
require("endoxide.lsp.null-ls")

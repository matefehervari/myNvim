local capabilities = vim.lsp.protocol.make_client_capabilities()

local cmp_lsp = require("cmp_nvim_lsp")
capabilities = cmp_lsp.default_capabilities(capabilities)

local on_attach = require("endoxide.lsp.lsp-onattach")

vim.lsp.config("*", {
    on_attach = on_attach,
    capabilities = capabilities
})

-- Required by rustaceanvim
vim.lsp.config("rust-analyzer", {
    on_attach = on_attach,
    capabilities = capabilities,
})

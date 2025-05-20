return {
    "williamboman/mason-lspconfig.nvim",
    requires = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function ()
        local mason_lsp = require("mason-lspconfig")
        mason_lsp.setup()
        mason_lsp.setup_handlers({
            require("endoxide.lsp.handlers")
        })
    end
}

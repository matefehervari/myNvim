return {
    "neovim/nvim-lspconfig", -- enable LSP
    config = function ()
        require("lspconfig.ui.windows").default_options.border = "rounded"
    end
}

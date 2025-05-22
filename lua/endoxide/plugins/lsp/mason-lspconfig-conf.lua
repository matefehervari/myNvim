return {
    "williamboman/mason-lspconfig.nvim",
    requires = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local mason_lsp = require("mason-lspconfig")
        local insert_all = require("endoxide.util.lua-utils").insert_all

        local lang_servers = require("endoxide.data.lang_lsps")

        local config = {
            ensure_installed = {
                -- Scripting
                "bashls",    -- Bash
                -- "checkmake", -- Makefile

                -- Webdev
                "cssls",                 -- CSS
                "cssmodules_ls",         -- CSS Modules
                "emmet_language_server", -- Emmet

                -- Data
                "jsonls",  -- Json

                -- Format
                "ruff",  -- Python
            }
        }

        insert_all(config.ensure_installed, lang_servers)

        mason_lsp.setup(config)
        mason_lsp.setup_handlers({
            require("endoxide.lsp.handlers")
        })
    end
}

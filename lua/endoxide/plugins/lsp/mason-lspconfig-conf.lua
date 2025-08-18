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
        local setup_server = require("endoxide.lsp.setup_server")

        local config = {
            ensure_installed = {
                -- Scripting
                "bashls", -- Bash
                -- "checkmake", -- Makefile

                -- Webdev
                "cssls",                 -- CSS
                "cssmodules_ls",         -- CSS Modules
                "emmet_language_server", -- Emmet

                -- Data
                "jsonls", -- Json

                -- Format
                "ruff", -- Python
            },
            automatic_enable = false,
        }

        insert_all(config.ensure_installed, lang_servers)

        mason_lsp.setup(config)

        local servers = mason_lsp.get_installed_servers()
        for _, server_name in ipairs(servers) do
            setup_server(server_name)
        end
    end
}

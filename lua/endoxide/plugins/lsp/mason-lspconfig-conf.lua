return {
    "williamboman/mason-lspconfig.nvim",
    requires = {
        "williamboman/mason.nvim",
        "neovim/nvim-lspconfig",
    },
    config = function()
        local mason_lsp = require("mason-lspconfig")

        local config = {
            ensure_installed = {
                -- Scripting
                "bashls",    -- Bash
                -- "checkmake", -- Makefile

                -- Webdev
                "cssls",                 -- CSS
                "cssmodules_ls",         -- CSS Modules
                "emmet_language_server", -- Emmet
                "ts_ls",                 -- Typescript

                -- Langs
                "clangd",        -- C, C++
                "hls",           -- Haskell
                "jdtls",         -- Java
                "lua_ls",        -- Lua
                "ocamllsp",      -- Ocaml
                "omnisharp",     -- C#
                "pyright",       -- Python
                "rust_analyzer", -- Rust
                "texlab",        -- Tex

                -- Data
                "jsonls",  -- Json

                -- Format
                "ruff",  -- Python
            }
        }

        mason_lsp.setup(config)
        mason_lsp.setup_handlers({
            require("endoxide.lsp.handlers")
        })
    end
}

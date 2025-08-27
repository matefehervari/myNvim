return {
    settings = {

        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.stdpath("config") .. "/lua",
                    "${3rd}/luv/library"
                },
            },
            hint = {
                enable = true
            },
            format = {
                enable = true,
                defaultConfig = {
                    indent_type = "Spaces",
                    indent_width = vim.o.tabstop,
                }
            }
        },
    },
}

return {
    "neovim/nvim-lspconfig", -- enable LSP
    config = function()
        local nnoremap = require("endoxide.keymap").nnoremap
        require("lspconfig.ui.windows").default_options.border = "rounded"

        nnoremap("<leader>fl", "<Cmd>LspInfo<CR>", { desc = "Open LspInfo" })
        nnoremap("<leader>glr", function()
            vim.cmd("LspRestart")
            vim.notify("Restarting LSP...")
        end, { desc = "Restart LSP" })
    end
}

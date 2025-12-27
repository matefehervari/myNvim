-- This is a module defining common LSP behaviour and appearance in Neovim
-- This configuration controls Neovim as a client only and performs no
-- configuration of LSP servers

-- Configure LSP Diagnostics
local text = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.HINT] = "",
    [vim.diagnostic.severity.INFO] = "",
}

---@type vim.diagnostic.Opts
local config = {
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
    signs = {
        text = text
    }
}

vim.diagnostic.config(config)

-- Unmap nvim default lsp mapping
vim.keymap.del("n", "grt")
vim.keymap.del("n", "gri")
vim.keymap.del("n", "gra")
vim.keymap.del("n", "grn")
vim.keymap.del({ "n" }, "grr")

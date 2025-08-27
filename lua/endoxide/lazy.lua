local fn = vim.fn

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    LAZY_BOOTSTRAP = fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    { import = "endoxide.plugins" },
    { import = "endoxide.plugins.lsp" },
    { import = "endoxide.plugins.files" },

    -- snippets
    "rafamadriz/friendly-snippets", -- a bunch of snippets to use

    -- lsp stuff
    -- "neovim/nvim-lspconfig", -- enable LSP
    "williamboman/mason.nvim", -- LSP installer
    "williamboman/mason-lspconfig.nvim",

    "jose-elias-alvarez/null-ls.nvim",

    -- Telescope
    "nvim-telescope/telescope-media-files.nvim",


    -- use "lewis6991/spellsitter.nvim"
    "JoosepAlviste/nvim-ts-context-commentstring",

    -- DAP
    "mfussenegger/nvim-dap",
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap" }
    },

    -- Python
    "mfussenegger/nvim-dap-python",

    -- Java
    "mfussenegger/nvim-jdtls",
}

local opts = {
    change_detection = {
        enabled = false,
        notify  = false,
    },
    ui = {
        border = "rounded",
    },
}

require("lazy").setup(plugins, opts)

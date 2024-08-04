local fn = vim.fn

local lazypath = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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
  "nvim-lua/popup.nvim", -- An implementation of the Popup API from vim in Neovim
  {import = "endoxide.plugins"},

  "windwp/nvim-ts-autotag", -- Autotags


  -- snippets
  "rafamadriz/friendly-snippets", -- a bunch of snippets to use

  -- colorscheme
  "folke/tokyonight.nvim",

  -- lsp stuff
  "neovim/nvim-lspconfig", -- enable LSP
  -- use("williamboman/nvim-lsp-installer") -- LSP installer
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
     dependencies = {"mfussenegger/nvim-dap"}
  },

-- Python
  "mfussenegger/nvim-dap-python",

  -- Java
  "mfussenegger/nvim-jdtls",


  -- Rust
  "simrat39/rust-tools.nvim",
}

local opts = {}

require("lazy").setup(plugins, opts)

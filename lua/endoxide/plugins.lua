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
  "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
  "windwp/nvim-autopairs", -- Autopairs
  "windwp/nvim-ts-autotag", -- Autotags
  "numToStr/Comment.nvim", -- Easily comment stuff
  "kyazdani42/nvim-web-devicons",
  "kyazdani42/nvim-tree.lua",
  "akinsho/bufferline.nvim",
  "akinsho/toggleterm.nvim",

  "hrsh7th/nvim-cmp", -- The completion plugin
  "hrsh7th/cmp-buffer", -- buffer completions
  "hrsh7th/cmp-path", -- path completions
  "hrsh7th/cmp-cmdline", -- cmdline completions
  "hrsh7th/cmp-nvim-lua", -- vim object completions
  "saadparwaiz1/cmp_luasnip", -- snippet completions
  "hrsh7th/cmp-nvim-lsp", -- cmp works with LSP
  "hrsh7th/cmp-nvim-lsp-signature-help", -- cmp signature help


  -- snippets
  "L3MON4D3/LuaSnip", --snippet engine
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
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-media-files.nvim",

  -- TreeSitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- use "lewis6991/spellsitter.nvim"
  "JoosepAlviste/nvim-ts-context-commentstring",

  -- DAP
  "mfussenegger/nvim-dap",
  {
    "rcarriga/nvim-dap-ui",
     dependencies = {"mfussenegger/nvim-dap"}
  },

  -- sessions
  "olimorris/persisted.nvim",

-- Python
  "mfussenegger/nvim-dap-python",

  -- Java
  "mfussenegger/nvim-jdtls",

  -- Latex
  "lervag/vimtex",

  -- Rust
  "simrat39/rust-tools.nvim",
}

local opts = {}

require("lazy").setup(plugins, opts)

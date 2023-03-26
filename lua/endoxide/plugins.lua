local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
  print("Installing packer close and reopen Neovim...")
  vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)

  use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
  use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
  use("windwp/nvim-autopairs") -- Autopairs
  use({
    "windwp/nvim-ts-autotag",
    wants = "nvim-treesitter"
  }) -- Autotags
  use "numToStr/Comment.nvim" -- Easily comment stuff
  use 'kyazdani42/nvim-web-devicons'
  use 'kyazdani42/nvim-tree.lua'
  use "akinsho/bufferline.nvim"
  use "akinsho/toggleterm.nvim"

  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "hrsh7th/cmp-nvim-lua" -- vim object completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp" -- cmp works with LSP

  -- snippets
  use {"L3MON4D3/LuaSnip", --snippet engine
    commit = "3fa5c8d938e4ed9dcfd3e07d13b587cba4f87e7d"}
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- colorscheme
  use("folke/tokyonight.nvim")

  -- lsp stuff
  use("neovim/nvim-lspconfig") -- enable LSP
  use("williamboman/nvim-lsp-installer") -- LSP installer
  use {"jose-elias-alvarez/null-ls.nvim",
    commit = "af12c0df06afb737c66eb91bf5eaf92bd2d01a42"}-- for formatters and linters

  -- Telescope
  use "nvim-telescope/telescope.nvim"
  use "nvim-telescope/telescope-media-files.nvim"

  -- TreeSitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  -- use 'lewis6991/spellsitter.nvim'
  use 'JoosepAlviste/nvim-ts-context-commentstring'

  -- DAP
  use "mfussenegger/nvim-dap"
  use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

  -- sessions
  use("olimorris/persisted.nvim")

  -- Python
  use "mfussenegger/nvim-dap-python"

  -- Java
  use "mfussenegger/nvim-jdtls"

  -- Latex
  use "lervag/vimtex"

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)

vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.errorbells = false

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- vim uses system clipboard
vim.opt.clipboard:append("unnamedplus")

-- mostly just for cmp
vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showtabline = 2                         -- always show tabs
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Give more space for displaying messages.
vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")

vim.opt.mousemoveevent = true
-- vim.g.matchparen_timeout = 2
-- vim.g.matchparen_insert_timeout = 2
-- vim.opt.loaded_matchparen = 1

vim.g.colorcolumn = "80"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd "set whichwrap+=<,>,[,],h,l"


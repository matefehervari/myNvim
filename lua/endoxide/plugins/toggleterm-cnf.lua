return {
  "akinsho/toggleterm.nvim",
  version = "*",

  config = function ()
    local toggleterm = require("toggleterm")

    local config = {
      size = 80,
      ide_numbers = true,
      shade_terminals = false,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      close_on_exit = true,
      env = {
        TOGGLETERM = "1"
      },
      highlights = {
        Normal = {
          guibg = "None",
        },
        SignColumn = {
          guibg = "None"
        }
      },
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    }

    toggleterm.setup(config)

    -- functions
    local Terminal = require("toggleterm.terminal").Terminal

    local node = Terminal:new({ cmd = "node", hidden = true, direction = "float" })

    function _NODE_TOGGLE()
      node:toggle()
    end

    local python = Terminal:new({ cmd = "python3", hidden = true, direction = "float" })
    local gitui = Terminal:new({ cmd = "gitui", hidden = true, direction = "float"})
    local swipl = Terminal:new({ cmd = "swipl", hidden = true, direction = "float"})

    function _PYTHON_TOGGLE()
      python:toggle()
      vim.api.nvim_buf_set_keymap(0, 't', '<S-Tab>', [[<C-\><C-n>:lua _PYTHON_TOGGLE()<cr>]], {noremap = true})
    end

    function _GITUI_TOGGLE()
      gitui:toggle()
      vim.api.nvim_buf_set_keymap(0, 't', '<S-Tab>', [[<C-\><C-n>:lua _GITUI_TOGGLE()<cr>]], {noremap = true})
    end

    function _SWIPL_TOGGLE()
      swipl:toggle()
      vim.api.nvim_buf_set_keymap(0, 't', '<S-Tab>', [[<C-\><C-n>:lua _SWIPL_TOGGLE()<cr>]], {noremap = true})
    end

    function _G.set_terminal_keymaps()
      local opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
      vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
    end

    -- keymaps
    local Remap = require("endoxide.keymap")
    local nnoremap = Remap.nnoremap

    vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

    nnoremap("<leader>tt", ":ToggleTerm direction=float dir=git_dir <CR>")
    nnoremap("<leader>tb", function ()
      local buffer_dir = vim.fn.expand("%:p:h")
      local command = (":ToggleTerm direction=float dir=%s <CR>"):format(buffer_dir)
      print(command)
      vim.cmd(command)
    end)
    nnoremap("<leader>tv", ":ToggleTerm direction=vertical<CR>")
    nnoremap("<leader>tp", _PYTHON_TOGGLE)
    nnoremap("<leader>tg", _GITUI_TOGGLE)
    nnoremap("<leader>ts", _SWIPL_TOGGLE)
  end
}

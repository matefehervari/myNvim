return {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    local minisurround = require("mini.surround")
    local keymap = require("endoxide.keymap")
    local vnoremap = keymap.nnoremap

    local config = {
      mappings = {
        add = 'msa',        -- Add surrounding in Normal and Visual modes
        delete = 'msd',     -- Delete surrounding
        find = 'msf',       -- Find surrounding (to the right)
        find_left = 'msF',  -- Find surrounding (to the left)
        replace = 'msr',    -- Replace surrounding
        update_n_lines = 'msn', -- Update `n_lines`
      },
    }

    minisurround.setup(config)
  end
}

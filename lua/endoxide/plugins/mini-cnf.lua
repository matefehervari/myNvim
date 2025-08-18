return {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
        local minisurround = require("mini.surround")
        local minialign = require("mini.align")
        local minisplitjoin = require("mini.splitjoin")


        minisurround.setup {
            mappings = {
                add            = 'msa', -- Add surrounding in Normal and Visual modes
                delete         = 'msd', -- Delete surrounding
                find           = 'msf', -- Find surrounding (to the right)
                find_left      = 'msF', -- Find surrounding (to the left)
                replace        = 'msr', -- Replace surrounding
                update_n_lines = 'msn', -- Update `n_lines`
            },
        }

        minialign.setup()

        minisplitjoin.setup {
            mappings = {
                toggle = "<leader>m",
                split = "<leader>s",
                join = "<leader>j",
            }
        }
    end
}

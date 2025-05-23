return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function ()
        local ibl = require("ibl")
        ibl.setup {
            indent = {
                char = "▏",
            },
            scope = {
                show_start = false,
                show_end = false,
                highlight = "Conceal",
            }
        }
    end
}

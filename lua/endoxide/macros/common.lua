
local autocommand = require("endoxide.autocommand")
local autocmd = autocommand.autocmd
local group = autocommand.endoxideGroup

autocmd({ "BufNew", }, {
    group = group,
    pattern = "*",
    callback = function()
        --- @type string
        local buf_ft = vim.api.nvim_get_option_value("filetype", {})


        local outputs = require("endoxide.data.std_out_map")

        local fmt_string = outputs[buf_ft]

        if fmt_string then
            vim.fn.setreg("l","viws" .. fmt_string:format("pa") .. "$")
        end
    end
})

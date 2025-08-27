local ls = require("luasnip")

local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

local std_out = require("endoxide.data.std_out_map").output
local dbg_out = require("endoxide.data.std_out_map").debug

local match_ft = function()
    local buf_ft = vim.api.nvim_get_option_value("filetype", {})
    return std_out[buf_ft] ~= nil
end

local never = function()
    return false
end

return {
    s({
            trig = "(%S+)%,,",
            regTrig = true,
            wordTrig = false,
            condition = match_ft,
            show_condition = never,
        },
        { f(function(_, parent)
            local buf_ft = vim.api.nvim_get_option_value("filetype", {})
            local out_fmt = std_out[buf_ft]

            return out_fmt:format(parent.snippet.captures[1])
        end) }),
    s({
            trig = "(%S+)%;;(%S*)",
            priority = 1001,
            regTrig = true,
            wordTrig = false,
            condition = match_ft,
            show_condition = never,
        },
        { f(function(_, parent)
            local capture = parent.snippet.captures[1]
            local message = parent.snippet.captures[2]
            local buf_ft = vim.api.nvim_get_option_value("filetype", {})
            local dbg_fmt = dbg_out[buf_ft]
            local dbg_message = capture
            if message then
                dbg_message = dbg_message .. " " .. message
            end

            return dbg_fmt:format(dbg_message, capture)
        end) }),

    s({
            trig = ",,",
            wordTrig = true,
            condition = match_ft,
            show_condition = never,
        },
        { f(function()
            local buf_ft = vim.api.nvim_get_option_value("filetype", {})
            local out_parts = std_out(buf_ft)

            return out_parts[1]
        end), i(1), f(function()
            local buf_ft = vim.api.nvim_get_option_value("filetype", {})
            local out_parts = std_out(buf_ft)

            return out_parts[2]
        end) }),
}

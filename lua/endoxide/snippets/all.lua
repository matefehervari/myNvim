local ls = require("luasnip")
local tsutil = require("endoxide.util.tsutils")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
local sn = ls.snippet_node
local postfix = require("luasnip.extras.postfix").postfix
local fmt = require("luasnip.extras.fmt").fmt
local fmt_angle = ls.extend_decorator.apply(fmt, { delimiters = "<>" })

local std_out = require("endoxide.data.std_out_map")

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

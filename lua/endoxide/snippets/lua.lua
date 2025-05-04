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

local snippets = {
    s({ trig = "autocmd" },
        fmt_angle(
        "autocmd({ \"<>\",<> }, {\n\tgroup = <>,\n\tpattern = \"<>\",\n\tcallback = function()\n\t\t<>\n\tend\n})",
            { i(1, "Trigger"), i(2), i(3, "nil"), i(4, "*.ext"), i(5) })),
}

return snippets

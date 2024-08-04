local ls = require("luasnip")

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function get_file_name()
  return vim.fn.expand("%:t"):gsub("%.%w+", "")
end

return {
  s({
    trig = "day",
    namr = "Day",
    dscr = "Advent of Code day template",
  }, {
    t({ "public class " }), f(get_file_name), t({ " extends Day {",
    "\t" }), i(0), t({ "", "\tpublic " }), f(get_file_name), t({ "(Path path) throws IOException {",
    "\t\tsuper(path);", "\t}", "", "\t@Override", "\tpublic String part1() {",
    "", "\t\treturn new String();", "\t}", "", "\t@Override",
    "\tpublic String part2() {", "", "\t\treturn new String();", "\t}", "}" }),
    f(function() require("jdtls").organize_imports() end)
  }),
}

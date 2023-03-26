local ls_status, ls = pcall(require, "luasnip")
if not ls_status then
  return
end
-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

function get_file_name()
  return vim.fn.expand("%:t"):gsub("%.%w+", "")
end

ls.add_snippets(nil, {
  java = {
    snip({
      trig = "day",
      namr = "Day",
      dscr = "Advent of Code day template",
    }, {
      text({"public class "}), func(get_file_name), text({" extends Day {",
      "\t"}), insert(0), text({"", "\tpublic "}), func(get_file_name), text({"(Path path) throws IOException {",
      "\t\tsuper(path);", "\t}", "", "\t@Override", "\tpublic String part1() {",
      "", "\t\treturn new String();", "\t}", "", "\t@Override",
      "\tpublic String part2() {", "", "\t\treturn new String();", "\t}", "}"}),
      func(function() require("jdtls").organize_imports() end)
    })
  },
  tex = {
    snip({
      trig = "todo",
      namr = "Day",
      dscr = "Add TODO item",
    }, {
      text({"% TODO"})
    })

  }
})

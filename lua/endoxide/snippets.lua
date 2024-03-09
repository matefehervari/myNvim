local ls_status, ls = pcall(require, "luasnip")
if not ls_status then
  return
end

vscode = require("luasnip.loaders.from_vscode")

-- some shorthands...
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

vscode.load {
  exclude = {"tex"}
}

function get_file_name()
  return vim.fn.expand("%:t"):gsub("%.%w+", "")
end

ls.config.set_config({
  enable_autosnippets = true
})

local tex_snippets = require("endoxide.snippets.latex")

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
  tex = tex_snippets
})


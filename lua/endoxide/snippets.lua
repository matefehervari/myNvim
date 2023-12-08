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

ls.config.set_config({
  enable_autosnippets = true
})

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
      namr = "Todo",
      dscr = "Add TODO item",
    }, {
      text({"% TODO"})
    }),
    snip({
      trig = "image",
      namr = "Image",
      dscr = "Add TODO item",
    }, {
      text({"\\begin{center}", "\t\\includegraphics[width=0.7\\columnwidth]{./diagrams/"}), insert(0), text({"}", "\\end{center}"})
    }),
    snip({ trig = "->", snippetType = "autosnippet" },
      {
        text({"\\rightarrow"})
      }
    ),
    snip({ trig = ";a", snippetType = "autosnippet" },
      {
        text({"\\alpha"})
      }
    ),
    snip({ trig = ";b", snippetType = "autosnippet" },
      {
        text({"\\beta"})
      }
    ),
    snip({ trig = ";g", snippetType = "autosnippet" },
      {
        text({"\\gamma"})
      }
    ),
    snip({ trig = ";d", snippetType = "autosnippet" },
      {
        text({"\\delta"})
      }
    ),
    snip({ trig = ";ep", snippetType = "autosnippet" },
      {
        text({"\\varepsilon"})
      }
    ),
    snip({ trig = ";z", snippetType = "autosnippet" },
      {
        text({"\\zeta"})
      }
    ),
    snip({ trig = ";et", snippetType = "autosnippet" },
      {
        text({"\\eta"})
      }
    ),
    snip({ trig = ";t", snippetType = "autosnippet" },
      {
        text({"\\theta"})
      }
    ),
    snip({ trig = ";k", snippetType = "autosnippet" },
      {
        text({"\\kappa"})
      }
    ),
    snip({ trig = ";l", snippetType = "autosnippet" },
      {
        text({"\\lambda"})
      }
    ),
    snip({ trig = ";m", snippetType = "autosnippet" },
      {
        text({"\\mu"})
      }
    ),
    snip({ trig = ";n", snippetType = "autosnippet" },
      {
        text({"\\nu"})
      }
    ),
    snip({ trig = ";p", snippetType = "autosnippet" },
      {
        text({"\\pi"})
      }
    ),
    snip({ trig = ";s", snippetType = "autosnippet" },
      {
        text({"\\sigma"})
      }
    ),
  }
})

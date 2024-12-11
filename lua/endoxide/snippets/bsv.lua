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

return {
    -- BSV Essentials
  s({ trig = "import" }, fmt_angle("import <>::*;", { i(1, "Package") })),
  s({ trig = "ifdef" }, fmt_angle("`ifdef\n<>\n`endif", { i(1) })),

  -- Structures
  s({ trig = "rule" },
    fmt_angle("rule <>;\n\t<>\nendrule", { i(1, "RuleName"), i(2) })),

  s({ trig = "method" },
    fmt_angle("method <> <>(<>);\n\t<>\nendmethod", { i(1, "ReturnType"), i(2, "MethodName"), i(3), i(4)})),

  s({ trig = "function" },
    fmt_angle("function <> <>(<>);\n\t<>\nendfunction", { i(1, "ReturnType"), i(2, "FunctionName"), i(3), i(4) })),

  s({ trig = "module" },
    fmt_angle("module <>(<>);\n\t<>\nendmodule", { i(1, "mkModule"), i(2, "IfcName"), i(3) })),

  s({ trig = "interface" },
    fmt_angle("interface <>;\n\t<>\nendinterface", { i(1, "IfcName"), i(2) })),

  s({ trig = "case" },
    fmt_angle("case(<>)\n\t<>\n\tdefault : <>;\nendcase", { i(1, "Value"), i(2), i(3, "DefaultValue") })),

  s({ trig = "casematch" },
    fmt_angle("case(<>) matches\n\t<>\n\tdefault : <>;\nendcase", { i(1, "Value"), i(2), i(3, "DefaultValue") })),

  s({ trig = "if" },
    fmt_angle("if (<>) begin\n\t<>\nend", { i(1, "Cond"), i(2) })),

  s({ trig = "elif" },
    fmt_angle("else if (<>) begin\n\t<>\nend", { i(1, "Cond"), i(2) })),

  s({ trig = "else" },
    fmt_angle("else begin\n\t<>\nend", { i(1) })),

  -- Type Constructors
  s({ trig = "bit" }, fmt_angle("Bit#(<>)", { i(1) })),
  s({ trig = "uint" }, fmt_angle("UInt#(<>)", { i(1) })),
  s({ trig = "int" }, fmt_angle("Int#(<>)", { i(1) })),
  s({ trig = "maybe" }, fmt_angle("Maybe#(<>)", { i(1) })),
  s({ trig = "reg" }, fmt_angle("Reg#(<>)", { i(1) })),
  s({ trig = "vector" }, fmt_angle("Vector#(<>)", { i(1) })),

  -- Type Constructor Expressions
  s({ trig = "mkreg" }, fmt("Reg#({}) {} <- mkReg({})", { i(1), i(2, "RegName"), i(3) })),
  s({ trig = "struct" }, fmt_angle("typedef struct {\n\t<>\n} <>", { i(1), i(2, "StructName") })),
  s({ trig = "enum" }, fmt_angle("typedef enum {\n\t<>\n} <>", { i(1), i(2, "EnumName") })),
  s({ trig = "deriving" }, fmt_angle("deriving(<>)", { i(1) })),
  s({ trig = "provisos" }, fmt_angle("provisos(<>)", { i(1) })),

  -- Provisos
  s({ trig = "bits" }, fmt_angle("Bits#(<>, <>)", { i(1, "TypeName"), i(2, "TypeSz") })),

  s({ trig = "nummeric" }, fmt_angle("numeric type <>", { i(1, "TypeName") })),
}

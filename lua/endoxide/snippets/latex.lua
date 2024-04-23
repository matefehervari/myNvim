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

local function is_escaped(str, symbol)
  return string.match(str, "\\" .. symbol .. "$")
end

-- conditions
local function math()
  -- return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
  return tsutil.in_mathzone()
end

local function notMath()
  return not math()
end

local function not_escaped(str, symbol)
  return not is_escaped(str, symbol)
end

local function math_not_escaped(str, symbol)
    return math() and not_escaped(str, symbol)
end

local function math_escaped(str, symbol)
    return math() and is_escaped(str, symbol)
end
--

local function insertAll(a, b)
  for _, elem in ipairs(b) do
    table.insert(a, elem)
  end
end

local function has_value (tbl, val)
    for idx = 1,#tbl do
        -- We grab the first index of our sub-table instead
        if tbl[idx] == val then
            return true
        end
    end

    return false
end

------------------------------------------------- Math mode environments

local math_mode = {
  s(
    { trig = "mk", snippetType = "autosnippet", condition = notMath },
    { t("$"), i(1), t("$") }
  ),

  s(
    { trig = "dm", snippetType = "autosnippet", condition = notMath },
    { t({ "\\[", "" }), i(1), t({ "\t", "\\]" }) }
  ),

}

--------------------------------------------------- Greek completion

local greek = {
  s({ trig = ";a", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\alpha") }),
  s({ trig = ";b", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\beta") }),
  s({ trig = ";c", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\chi") }),
  s({ trig = ";g", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\gamma") }),
  s({ trig = ";G", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\Gamma") }),
  s({ trig = ";d", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\delta") }),
  s({ trig = ";D", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\Delta") }),
  s({ trig = ";e", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\varepsilon") }),
  s({ trig = ";E", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\epsilon") }),
  s({ trig = ";z", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\zeta") }),
  s({ trig = ";t", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\theta") }),
  s({ trig = ";k", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\kappa") }),
  s({ trig = ";l", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\lambda") }),
  s({ trig = ";L", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\Lambda") }),
  s({ trig = ";m", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\mu") }),
  s({ trig = ";r", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\rho") }),
  s({ trig = ";s", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\sigma") }),
  s({ trig = ";S", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\Sigma") }),
  s({ trig = ";o", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\omega") }),
  s({ trig = ";O", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\Omega") }),
  s({ trig = ";u", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\upsilon") }),
  s({ trig = ";U", snippetType = "autosnippet", condition = math, wordTrig = false }, { t("\\Upsilon") }),
}

------------------------------ Symbol modifiers

local GREEK =
{ "alpha", "beta", "gamma", "Gamma", "delta", "Delta", "epsilon", "varepsilon", "zeta", "eta", "theta", "Theta", "iota",
  "kappa", "lambda", "Lambda", "mu", "nu", "omicron", "xi", "Xi", "pi", "Pi", "rho", "sigma", "Sigma", "tau", "upsilon",
  "Upsilon", "varphi", "phi", "Phi", "chi", "psi", "Psi", "omega", "Omega" }

local SYMBOL =
{ "hbar", "ell", "nabla", "infty", "dots", "leftrightarrow", "uparrow", "downarrow", "mapsto", "setminus", "mid", "bigcap", "bigcup", "cap",
  "cup", "land", "lor", "subseteq", "subset", "implies", "impliedby", "iff", "exists", "forall", "equiv", "square", "neq",
  "geq", "leq", "gg", "ll", "sim", "simeq", "approx", "propto", "cdot", "oplus", "otimes", "times", "star", "perp", "det",
  "exp", "ln", "log", "partial", "vdash", "triangleq", "twoheadrightarrow", "uplus", "Longrightarrow", "therefore"}

local SHORT_SYMBOL = { "to", "pm", "mp", "in"}

local ALL_SYMBOLS = {}
insertAll(ALL_SYMBOLS, GREEK)
insertAll(ALL_SYMBOLS, SYMBOL)
insertAll(ALL_SYMBOLS, SHORT_SYMBOL)

local SYMBOLS = {}
insertAll(SYMBOLS, SYMBOL)
insertAll(SYMBOLS, SHORT_SYMBOL)

local function toTexCommand(symbol)
  return s(
    { trig = "(" .. symbol .. ")", snippetType = "autosnippet", 
    condition = math_not_escaped, -- line_to_cursor and matched trigger correspond to str and symbol
    regTrig = true },  -- wordTrig = false
    { f(function(_, s)
      return "\\" .. s.captures[1]
    end) }
  )
end

local function symbolInsertSpaceTrig(trig)
  return function(symbolName)
    local texsymb = "\\" .. symbolName
    return postfix({
        trig = trig,
        snippetType = "autosnippet",
        match_pattern = texsymb,
        regTrig = true,
        condition = function(line_to_cursor, matched_trigger)
          local endsWithSymbol = (line_to_cursor:sub(-(#texsymb + #matched_trigger)) == (texsymb .. matched_trigger))
          return math() and endsWithSymbol
        end
      },
      {
        f(function(_, parent)
          return parent.snippet.env.POSTFIX_MATCH .. " " .. parent.snippet.trigger
        end, {}),
      })
  end
end

local symbolModifierMap = {
  sr = [[<>^{2}]],
  cb = [[<>^{3}]],
  invs = [[<>^{-1}]],
  rd = [[<>^{<>}]],
  hat = [[\hat{<>}]],
  dot = [[\dot{<>}]],
  bar = [[\bar{<>}]],
  vec = [[\vec{<>}]],
  tilde = [[\tilde{<>}]],
  und = [[\underline{<>}]],
  ddot = [[\ddot{<>}]],
}

local function getSymbolModifierSnippet(symbolName, modifier)
  local texsymb = "\\" .. symbolName
  local match = texsymb .. " "
  return postfix({
      trig = modifier,
      snippetType = "autosnippet",
      match_pattern = match,
      condition = function(line_to_cursor, matched_trigger)
        local endsWithSymbol = (line_to_cursor:sub(-(#match + #matched_trigger)) == (match .. matched_trigger))
        return math() and endsWithSymbol
      end
    },
    fmt_angle(symbolModifierMap[modifier], { t(texsymb), i(1) }, { strict = false }))
end

local function getPatternModifierSnippet(pattern, modifier)
  return postfix({
      trig = modifier,
      snippetType = "autosnippet",
      match_pattern = pattern,
      regTrig = true,
      condition = math,
      -- condition = function(line_to_cursor, matched_trigger)
      --   local endsWithSymbol = (line_to_cursor:sub(-(#pattern + #matched_trigger)) == (pattern .. matched_trigger))
      --   return math() and endsWithSymbol
      -- end
    },
    fmt_angle(
      symbolModifierMap[modifier],
      { f(function(_, parent)
        return parent.snippet.env.POSTFIX_MATCH
      end, {}), i(1) },
      { strict = false }
    )
  )
end

local modifier_snippets = {}
for _, symbol in ipairs(ALL_SYMBOLS) do
  for modifier, _ in pairs(symbolModifierMap) do
    table.insert(modifier_snippets, getSymbolModifierSnippet(symbol, modifier))
  end
end

for modifier, _ in pairs(symbolModifierMap) do
  table.insert(modifier_snippets, getPatternModifierSnippet("%a+$", modifier))
end

------------------------------------ Operations

local operation_fmts = {
  bf = fmt_angle([[\mathbf{<>}]], { i(1) }),
  sr = { t([[^{2}]]) },
  cb = { t([[^{3}]]) },
  rd = fmt_angle([[^{<>}]], { i(1) }),
  sts = fmt_angle([[_\text{<>}]], { i(1) }),
  sq = fmt_angle([[\sqrt{<>}]], { i(1) }),
  ["//"] = fmt_angle([[\frac{<>}{<>}]], { i(1), i(2) }),
  ee = fmt_angle([[\e^{<>}]], { i(1) }),
  rm = fmt_angle([[\mathrm{<>}]], { i(1) }),
}

local operation_snippets = {
  s({ trig = "_", snippetType = "autosnippet", condition = math, wordTrig = false }, fmt_angle([[_{<>}]], { i(1) })),
  s({ trig = "te", snippetType = "autosnippet", condition = math_not_escaped}, 
    fmt_angle("\\text{<>}", { i(1) })),
}
for trig, nodes in pairs(operation_fmts) do
  table.insert(
    operation_snippets,
    s({ trig = trig, wordTrig = false, snippetType = "autosnippet", condition = math }, nodes)
  )
end

------------------------------------ Symbols

local symbolic_trig_symbol_nodes = {
  ["+-"]     = { t("\\pm") },
  ["-+"]     = { t("\\mp") },
  ["..."]    = { t("\\dots") },
  ["->"]     = { t("\\to") },
  ["\\to>"]     = { t("\\twoheadrightarrow") },
  ["\\to\\"]     = { t("\\uparrow") },
  ["\\to/"]     = { t("\\downarrow") },
  ["!>"]     = { t("\\mapsto") },
  ["|-"]     = { t("\\vdash") },
  ["\\\\\\"] = { t("\\setminus") },
  ["||"]     = { t("\\mid") },
  ["=>"]     = { t("\\Longrightarrow") },
  ["=<"]     = { t("\\Longleftarrow") },
  ["-\\"]    = { t("\\rightharpoonup") },
  ["==="]    = { t("\\equiv") },
  ["!="]     = { t("\\neq") },
  [">="]     = { t("\\geq") },
  ["<="]     = { t("\\leq") },
  [">>"]     = { t("\\gg") },
  ["<<"]     = { t("\\ll") },
  ["~~"]     = { t("\\sim") },
  ["**"]     = { t("\\cdot") }
}

local symbols_nodes = {
  ["ooo"]          = { t("\\infty") },
  ["sum"]          = { t("\\sum") },
  ["prod"]         = { t("\\prod") },
  ["lim"]          = fmt_angle([[\lim_{ <> \to <> }]], { i(1, "n"), i(2, "\\infty") }),
  ["invs"]         = { t("^{-1}") },
  ["pfun"]         = { t("\\pfun") },
  ["and"]          = { t("\\cap") },
  ["orr"]          = { t("\\cup") },
  ["inn"]          = { t("\\in") },
  ["notin"]        = { t("\\not\\in") },
  ["\\subset eq"]  = { t("\\subseteq") },
  ["eset"]         = { t("\\emptyset") },
  ["set"]          = fmt_angle("\\{ <> \\}", { i(1) }),
  ["iff"]          = { t("\\iff") },
  ["Sq"]           = { t("\\square") },
  ["\\sim~"]       = { t("\\approx") },
  ["~="]           = { t("\\simeq") },
  ["\\simeq="]     = { t("\\cong") },
  ["prop"]         = { t("\\propto") },
  ["nabl"]         = { t("\\nabla") },
  ["del"]          = { t("\\nabla") },
  ["xx"]           = { t("\\times") },
  ["para"]         = { t("\\parallel") },
  ["mcal"]         = fmt_angle([[\mathcal{<>}]], i(1)),
  ["mbb"]          = fmt_angle([[\mathbb{<>}]], i(1)),
  ["ell"]          = { t("\\ell") },
  ["treq"]          = { t("\\triangleq") },
  ["f\\ora \\ll"]          = { t("\\forall") },
  ["thf"]          = { t("\\therefore") },
  ["ora"]          = fmt_angle([[\ora{<>}]], {i(1)}),

  ["AA"]           = { t("\\mathbb{A}") },
  ["BB"]           = { t("\\mathbb{B}") },
  ["CC"]           = { t("\\mathbb{C}") },
  ["DD"]           = { t("\\mathbb{D}") },
  ["EE"]           = { t("\\mathbb{E}") },
  ["FF"]           = { t("\\mathbb{F}") },
  ["GG"]           = { t("\\mathbb{G}") },
  ["HH"]           = { t("\\mathbb{H}") },
  ["II"]           = { t("\\mathbb{I}") },
  ["JJ"]           = { t("\\mathbb{J}") },
  ["KK"]           = { t("\\mathbb{K}") },
  ["LL"]           = { t("\\mathbb{L}") },
  ["MM"]           = { t("\\mathbb{M}") },
  ["NN"]           = { t("\\mathbb{N}") },
  ["OO"]           = { t("\\mathbb{O}") },
  ["PP"]           = { t("\\mathbb{P}") },
  ["QQ"]           = { t("\\mathbb{Q}") },
  ["RR"]           = { t("\\mathbb{R}") },
  ["SS"]           = { t("\\mathbb{S}") },
  ["TT"]           = { t("\\mathbb{T}") },
  ["UU"]           = { t("\\mathbb{U}") },
  ["VV"]           = { t("\\mathbb{V}") },
  ["WW"]           = { t("\\mathbb{W}") },
  ["XX"]           = { t("\\mathbb{X}") },
  ["YY"]           = { t("\\mathbb{Y}") },
  ["ZZ"]           = { t("\\mathbb{Z}") },
  ["LAB"]          = { t("\\mathbb{LAB}") },

  ["\\mathbb{A}A"] = { t("\\mathcal{A}") },
  ["\\mathbb{B}B"] = { t("\\mathcal{B}") },
  ["\\mathbb{C}C"] = { t("\\mathcal{C}") },
  ["\\mathbb{D}D"] = { t("\\mathcal{D}") },
  ["\\mathbb{E}E"] = { t("\\mathcal{E}") },
  ["\\mathbb{F}F"] = { t("\\mathcal{F}") },
  ["\\mathbb{G}G"] = { t("\\mathcal{G}") },
  ["\\mathbb{H}H"] = { t("\\mathcal{H}") },
  ["\\mathbb{I}I"] = { t("\\mathcal{I}") },
  ["\\mathbb{J}J"] = { t("\\mathcal{J}") },
  ["\\mathbb{K}K"] = { t("\\mathcal{K}") },
  ["\\mathbb{L}L"] = { t("\\mathcal{L}") },
  ["\\mathbb{M}M"] = { t("\\mathcal{M}") },
  ["\\mathbb{N}N"] = { t("\\mathcal{N}") },
  ["\\mathbb{O}O"] = { t("\\mathcal{O}") },
  ["\\mathbb{P}P"] = { t("\\mathcal{P}") },
  ["\\mathbb{Q}Q"] = { t("\\mathcal{Q}") },
  ["\\mathbb{R}R"] = { t("\\mathcal{R}") },
  ["\\mathbb{S}S"] = { t("\\mathcal{S}") },
  ["\\mathbb{T}T"] = { t("\\mathcal{T}") },
  ["\\mathbb{U}U"] = { t("\\mathcal{U}") },
  ["\\mathbb{V}V"] = { t("\\mathcal{V}") },
  ["\\mathbb{W}W"] = { t("\\mathcal{W}") },
  ["\\mathbb{X}X"] = { t("\\mathcal{X}") },
  ["\\mathbb{Y}Y"] = { t("\\mathcal{Y}") },
  ["\\mathbb{Z}Z"] = { t("\\mathcal{Z}") },
}

local function symbolNodesToSnippets(trig, nodes, wordTrig)
  return s({ trig = trig, snippetType = "autosnippet", condition = math, wordTrig = wordTrig }, nodes)
end

local symbol_snippets = {
  s({ trig = "<->", snippetType = "autosnippet", condition = math, priority = 1001 }, { t([[\leftrightarrow]]) }), -- priority over ->

  -- conflicting symbols with "invs" that end in 'i'
  s({ trig = "\\xi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[x^{-1}]]) }),
  s({ trig = "\\Xi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[X^{-1}]]) }),
  s({ trig = "\\phi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[ph^{-1}]]) }),
  s({ trig = "\\Phi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[Ph^{-1}]]) }),
  s({ trig = "\\chi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[ch^{-1}]]) }),
  s({ trig = "\\psi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[ps^{-1}]]) }),
  s({ trig = "\\Psi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[Ps^{-1}]]) }),
  s({ trig = "\\pi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[p^{-1}]]) }),
  s({ trig = "\\Pi nvs", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[p^{-1}]]) }),
  s({ trig = "e\\xi sts", snippetType = "autosnippet", condition = math, priority = 1001, wordTrig = false },
    { t([[\exists]]) }),
}


for trig, nodes in pairs(symbolic_trig_symbol_nodes) do
  table.insert(symbol_snippets, symbolNodesToSnippets(trig, nodes, false))
end

for trig, nodes in pairs(symbols_nodes) do
  table.insert(symbol_snippets, symbolNodesToSnippets(trig, nodes, true))
end

-- {trigger: "xnn", replacement: "x_{n}", options: "mA"},
-- {trigger: "xii", replacement: "x_{i}", options: "mA"},
-- {trigger: "xjj", replacement: "x_{j}", options: "mA"},
-- {trigger: "xp1", replacement: "x_{n+1}", options: "mA"},
-- {trigger: "ynn", replacement: "y_{n}", options: "mA"},
-- {trigger: "yii", replacement: "y_{i}", options: "mA"},
-- {trigger: "yjj", replacement: "y_{j}", options: "mA"},

------------------------------------ Derivatives

local derivative_snippets = {
  s({ trig = "par", condition = math }, fmt_angle([[\frac{ \partial <> }{ \partial <> }]], { i(1, "y"), i(2, "x") })),
  s({ trig = "pa2", snippetType = "autosnippet", condition = math },
    fmt_angle([[\frac{ \partial^{2} <> }{ \partial <>^{2} }]], { i(1, "y"), i(2, "x") })),
  s({ trig = "pa3", snippetType = "autosnippet", condition = math },
    fmt_angle([[\frac{ \partial^{3} <> }{ \partial <>^{3} }]], { i(1, "y"), i(2, "x") })),
  s({
      trig = "pa(%a)(%a)",
      condition = math,
      regTrig = true
    },
    fmt_angle([[\frac{ \partial <> }{ \partial <> }]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end
      ),
        f(function(_, parent)
          return parent.snippet.captures[2]
        end
        ),
      })
  ),

  s({
      trig = "pa(%a)(%a)(%a)",
      condition = math,
      regTrig = true
    },
    fmt_angle([[\frac{ \partial^{2} <> }{ \partial <> \partial <> }]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end
      ),
        f(function(_, parent)
          return parent.snippet.captures[2]
        end
        ),
        f(function(_, parent)
          return parent.snippet.captures[3]
        end
        ),
      })
  ),

  s({
      trig = "pa(%a)(%a)2",
      snippetType = "autosnippet",
      condition = math,
      regTrig = true
    },
    fmt_angle([[\frac{ \partial^{2} <> }{ \partial <>^{2} }]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end
      ),
        f(function(_, parent)
          return parent.snippet.captures[2]
        end
        ),
      })
  ),

  s({
      trig = "de(%a)(%a)",
      condition = math,
      regTrig = true
    },
    fmt_angle([[\frac{ d <> }{ d <> }]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end
      ),
        f(function(_, parent)
          return parent.snippet.captures[2]
        end
        ),
      })
  ),

  s({
      trig = "de(%a)(%a)2",
      condition = math,
      snippetType = "autosnippet",
      regTrig = true
    },
    fmt_angle([[\frac{ d^{2} <> }{ d <>^{2} }]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end
      ),
        f(function(_, parent)
          return parent.snippet.captures[2]
        end
        ),
      })
  ),

  s({
      trig = "ddx",
      condition = math,
      snippetType = "autosnippet",
      regTrig = true
    },
    { t("\\frac{d}{dx}") }
  ),
}

------------------------------------ Integrals

local integral_snippets = {
  s({ trig = "oinf", snippetType = "autosnippet", condition = math },
    fmt_angle([[\integral_{0}^{\infty} <> \, d<>]], { i(1), i(2, "x") })),
  s({ trig = "infi", snippetType = "autosnippet", condition = math },
    fmt_angle([[\integral_{-\infty}^{\infty} <> \, d<>]], { i(1), i(2, "x") })),
  s({ trig = "dint", snippetType = "autosnippet", condition = math },
    fmt_angle([[\integral_{<>}^{<>} <> \, d<>]], { i(1, "0"), i(2, "\\infty"), i(3), i(4, "x") })),
  s({ trig = "oint", snippetType = "autosnippet", condition = math },
    { t("\\oint") }),
  s({ trig = "int", snippetType = "autosnippet", condition = math },
    fmt_angle([[\integral <> \, d<>]], { i(1), i(2, "x") })),
}

------------------------------------ Environments

local environment_snippets = {
  s({ trig = "case", snippetType = "autosnippet", condition = math_not_escaped },
    fmt_angle("\\begin{cases}\n  <>\n\\end{cases}", { i(1) })),
  s({ trig = "align", condition = notMath },
    fmt_angle("\\begin{align*}\n  <>\n\\end{align*}", { i(1) })),
  s({ trig = "alignat", condition = notMath },
    fmt_angle("\\begin{alignat*}{<>}\n  <>\n\\end{alignat*}", { i(1), i(2) })),
  s({ trig = "array", snippetType = "autosnippet", condition = math_not_escaped },
    fmt_angle("\\begin{array}{<>}\n  <>\n\\end{array}", { i(1), i(2) })),
  s(
    { trig = "beg", snippetType = "autosnippet", condition = not_escaped},
    fmt_angle("\\begin{<>}\n  <>\n\\end{<>}",
      { i(1, "env"),
        i(3),
        d(2, function(args)
          return sn(nil, t(args[1][1]))
        end, { 1 })
      })
  ),
  s({ trig = "enum", condition=notMath},
    fmt_angle("\\begin{enumerate}\n  <>\n\\end{enumerate}", { i(1) })),
  s({ trig = "exam"},
    fmt_angle("\\begin{examquestion}{<>}{<>}{<>}\n<>\n\\end{examquestion}", { i(1), i(2), i(3), i(4) })),
  s({ trig = "listing"},
    fmt_angle("\\begin{lstlisting}\n<>\n\\end{lstlisting}", { i(1) })),
  s({ trig = "RTP"},
    fmt_angle("\\begin{RTP}{<>}\n  <>\n\\end{RTP}", { i(1), i(2) })),
  s({ trig = "cases", condition=notMath},
    fmt_angle("\\begin{proofcase}\n  <>\n\\end{proofcase}", { i(1) })),
  s({ trig = "center", condition=notMath},
    fmt_angle("\\begin{center}\n  <>\n\\end{center}", { i(1) })),
}

------------------------------------ Subscript snippets

local function subscriptSymbol(symbol)
  local texsymb = "\\" .. symbol
  return s({ trig = texsymb .. "(%d)", snippetType = "autosnippet", condition = math, regTrig = true },
    fmt_angle(texsymb .. [[_{<>}<>]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end),
        i(1)
      })
  )
end

local subscript_snippets = {
  s({ trig = "(%a)(%d)",  -- add subscript for variables
  snippetType = "autosnippet",
  -- condition = math,
  condition = function(line_to_cursor, matched_trigger)
    local symbol_pattern = "\\(%a+)%d$"
    local _, _, symbol = string.find(line_to_cursor, symbol_pattern)
    if symbol and not has_value(GREEK, symbol) then  -- do not subscript if not greek
      return false
    end

    return math()  -- only subscript if in math
  end,
  regTrig = true,
  wordTrig = false },

    fmt_angle([[<>_{<>}]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end),
        f(function(_, parent)
          return parent.snippet.captures[2]
        end)
      })
  ),

  s({ trig = "(%a)(%a)(%a)",  -- add alpha subscript for variables
  snippetType = "autosnippet",
  -- condition = math,
  condition = function(line_to_cursor, matched_trigger)
    local symbol_pattern = "\\(%a+)%a%a$"
    local _, _, symbol = string.find(line_to_cursor, symbol_pattern)
    if symbol and not has_value(GREEK, symbol) then  -- do not subscript if not greek
      return false
    end

    local len = string.len(line_to_cursor)
    local first_letter = line_to_cursor:sub(len - 1, len - 1)
    local second_letter = line_to_cursor:sub(len, len)
    print("got here")
    print(first_letter .. " + " .. second_letter)
    return math() and (first_letter == second_letter)  -- only subscript if in math
  end,
  regTrig = true,
  wordTrig = false },

    fmt_angle([[<>_{<>}]],
      { f(function(_, parent)
        return parent.snippet.captures[1]
      end),
        f(function(_, parent)
          return parent.snippet.captures[2]
        end)
      })
  )
}

insertAll(subscript_snippets, vim.tbl_map(subscriptSymbol, GREEK)) -- add subscript for greek symbols

------------------------------------ Misc

local misc_snippets = {
  s({ trig = "ang", snippetType = "autosnippet", condition = math },
    fmt_angle("\\langle <> \\rangle", { i(1) })),
  s({ trig = "dang", snippetType = "autosnippet", condition = math },
    fmt_angle("\\dlangle <> \\drangle", { i(1) })),
  s({ trig = "norm", snippetType = "autosnippet", condition = math },
    fmt_angle("\\lvert <> \\rvert", { i(1) })),
  s({ trig = "mod", snippetType = "autosnippet", condition = math },
    fmt_angle("\\lvert <> \\rvert", { i(1) })),
  s({ trig = "ceil", snippetType = "autosnippet", condition = math },
    fmt_angle("\\lceil <> \\rceil", { i(1) })),
  s({ trig = "floor", snippetType = "autosnippet", condition = math },
    fmt_angle("\\lfloor <> \\rfloor", { i(1) })),
  s({ trig = "uco", snippetType = "autosnippet", condition = math },
    fmt_angle("\\ulcorner <> \\urcorner", { i(1) })),
  s({ trig = "lco", snippetType = "autosnippet", condition = math },
    fmt_angle("\\llcorner <> \\lrcorner", { i(1) })),

  -- note the rhs brackets are omitted as it is completed by autopairs
  s({ trig = "lr(", snippetType = "autosnippet", condition = math },
    fmt_angle("\\left( <> \\right", { i(1) })),
  s({ trig = "lr|", snippetType = "autosnippet", condition = math },
    fmt_angle("\\left| <> \\right|", { i(1) })),
  s({ trig = "lr{", snippetType = "autosnippet", condition = math },
    fmt_angle("\\left{ <> \\right", { i(1) })),
  s({ trig = "lr[", snippetType = "autosnippet", condition = math },
    fmt_angle("\\left[ <> \\right", { i(1) })),
  s({ trig = "lra", snippetType = "autosnippet", condition = math },
    fmt("\\left< {} \\right>", { i(1) })),

  s({
    trig = "todo",
    namr = "Todo",
    dscr = "Add TODO item",
    snippetType = "autosnippet",
  }, {
    t({ "% TODO" })
  }),
  s({
      trig = "image",
      namr = "Image",
      dscr = "Insert default centered supervision image",
    },
    fmt_angle("\\begin{center}\n  \\includegraphics[width=0.7\\columnwidth]{./diagrams/<>}\n\\end{center}", { i(1) })
  ),
  s({ trig = "hsp", snippetType = "autosnippet"},
    fmt_angle("\\hspace{<>em}", { i(1) })),

  -- Custom commands
  s({ trig = "enumq", snippetType = "autosnippet", condition = not_escaped },
    fmt_angle("\\enumq{<>}", { i(1) })),
  s({ trig = "it", command = notMath },
    fmt_angle("\\textit{<>}", { i(1) })),
  s({ trig = "bf", command = notMath },
    fmt_angle("\\textbf{<>}", { i(1) })),
  s({ trig = "ud", command = notMath },
    fmt_angle("\\underline{<>}", { i(1) })),
  s({ trig = "ud", condition = math },
    fmt_angle("\\underline{<>}", { i(1) })),
  s({ trig = "boxc"},
    fmt_angle("\\boxc{<>}", { i(1) })),
  s({ trig = "boxed"},
    fmt_angle("\\boxed{<>}", { i(1) })),
  s({ trig = "(%d+)marks",  -- add subscript for variables
    snippetType = "autosnippet",
    regTrig = true,
    wordTrig = false },

      fmt_angle([[\signed{[<> marks]}]],
        { f(function(_, parent)
          return parent.snippet.captures[1]
        end),
        })
  ),
  s({ trig = "1mark",
    snippetType = "autosnippet",
    regTrig = true,
    wordTrig = false },
    t("\\signed{[1 mark]}")),

  -- Semantics
  s({ trig = "tfun", snippetType = "autosnippet", condition = math },
    fmt_angle("\\text{fn}\\ <> : <> \\implies <>", { i(1), i(2), i(3) })),

  s({ trig = "fun", snippetType = "autosnippet", condition = math },
    fmt_angle("\\text{fn}\\ <> \\implies <>", { i(1), i(2) })),

  s({ trig = "if", condition = math },
    fmt_angle("\\text{if}\\ <>\\ \\text{then}\\ <>\\ \\text{else}\\ <>", { i(1), i(2), i(3) })),

  s({ trig = "if2", condition = math },
    fmt_angle("\\text{if}\\ <>\\ \\text{then}\\ <>", { i(1), i(2) })),

  s({ trig = "lbnf", condition = math, snippetType = "autosnippet" },
    fmt_angle("\\lineBNF <> \\stopBNF", { i(1) })),

  s({ trig = "hlist", condition = math, snippetType = "autosnippet" },
    fmt_angle("\\hlist <> \\stophlist", { i(1) })),

  s({ trig = "oprule", condition = math, snippetType = "autosnippet" },
    fmt_angle("\\oprule{<>}{<>}{<>}", { i(1), i(2), i(3) })),

  s({ trig = "noprule", condition = math, snippetType = "autosnippet", priority = 1001},
    fmt_angle("\\noprule{<>}{<>}", { i(1), i(2) })),

  s({ trig = "dom", condition = not_escaped},
    fmt_angle("\\mathrm{dom}(<>)", { i(1) })),
  s({ trig = "loc", condition = not_escaped},
    fmt_angle("\\mathrm{loc}(<>)", { i(1) })),
  s({ trig = "closed", condition = not_escaped},
    fmt_angle("\\mathrm{closed}(<>)", { i(1) })),
  s({ trig = "fv", condition = not_escaped},
    fmt_angle("\\mathrm{fv}(<>)", { i(1) })),

   -- Proofs 

  s({ trig = "case"},
    fmt_angle("\\case{<>}", { i(1) })),
  s({ trig = "assume"},
    fmt_angle("\\assumption{<>}{<>}", { i(1), i(2) })),
  s({ trig = "rule"},
    fmt_angle("\\inlrule{<>}", { i(1) })),
  s({ trig = "res", condition = not_escaped},
    fmt_angle("\\result{<>}", { i(1) })),
  s({ trig = "by", condition = not_escaped},
    fmt_angle("\\by{<>}", { i(1) })),

  -- Computation Theory

  s({ trig = "\\implies*", condition = math_not_escaped},
    t("\\impliesst")),
  s({ trig = "\\implies+", condition = math_not_escaped},
    t("\\impliespl")),
}
------------------------------------ Add the snippets

local snippets = {}
insertAll(snippets, math_mode)

insertAll(snippets, greek)                                                 -- greek snippets from shortcuts
insertAll(snippets, vim.tbl_map(toTexCommand, GREEK))                      -- greek snippets from names
insertAll(snippets, vim.tbl_map(toTexCommand, SYMBOL))                     -- symbol snippets from names

insertAll(snippets, vim.tbl_map(symbolInsertSpaceTrig("%a"), ALL_SYMBOLS)) -- add spaces after all symbols on alphanumeric
insertAll(snippets, vim.tbl_map(symbolInsertSpaceTrig("%d"), SYMBOLS))     -- add spaces after symbols for on number
insertAll(snippets, modifier_snippets)                                     -- add modifiers to symbols
insertAll(snippets, operation_snippets)                                    -- add general operations
insertAll(snippets, symbol_snippets)                                       -- add symbol snippets
insertAll(snippets, derivative_snippets)                                   -- deriative snippets
insertAll(snippets, integral_snippets)                                     -- deriative snippets
insertAll(snippets, environment_snippets)                                  -- deriative snippets
insertAll(snippets, misc_snippets)                                         -- misc snippets
insertAll(snippets, subscript_snippets)

return snippets

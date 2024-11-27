local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")


---------- Pairs -------------
local latex_deletion_symbols = {
  [[<>^{-1}]],
  [[\hat{<>}]],
  [[\dot{<>}]],
  [[\bar{<>}]],
  [[\vec{<>}]],
  [[\tilde{<>}]],
  [[\underline{<>}]],
  [[\ddot{<>}]],

  [[^{<>}]],
  [[_{<>}]],
  [[\text{<>}]],

  [[\mathbf{<>}]],
  [[_\text{<>}]],
  [[\sqrt{<>}]],
  [[\frac{<>}{<>}]],
  [[\e^{<>}]],
  [[\mathrm{<>}]],

  -- big brackets
  "\\left[<>\\right]",
  "\\left[ <> \\right]",

  [[\left(<>\right)]],
  [[\left( <> \right)]],

  [[\left\{<>\right\}]],
  [[\left\{ <> \right\}]],


  [[\langle<>\rangle]],
  [[\dlangle<>\drangle]],
  [[\lvert<>\rvert]],
  [[\lvert<>\rvert]],
  [[\lceil<>\rceil]],
  [[\lfloor<>\rfloor]],
  [[\ulcorner<>\urcorner]],
  [[\llcorner<>\lrcorner]],

  [[\langle <> \rangle]],
  [[\dlangle <> \drangle]],
  [[\lvert <> \rvert]],
  [[\lvert <> \rvert]],
  [[\lceil <> \rceil]],
  [[\lfloor <> \rfloor]],
  [[\ulcorner <> \urcorner]],
  [[\llcorner <> \lrcorner]],

  [[\assumption{<>}{<>}]],
  [[\inlrule{<>}]],
  [[\result{<>}]],
  [[\by{<>}]]
}

---------- Helpers -----------

local function slice(tbl, first, last, step)
  local sliced = {}

  for i = first or 1, last or #tbl, step or 1 do
    sliced[#sliced + 1] = tbl[i]
  end

  return sliced
end

local function concat_slice(tbl, first)
  return table.concat(slice(tbl, first), "")
end

local function get_delete_rule(lhs, rhs)
  local delete_rule = Rule(lhs, rhs, "tex"):with_pair(cond.none())
  return delete_rule
end


---@param fmt_str string
local fmt_angle_to_pair_delete_rules = function(fmt_str)
  local pair_parts = {}
  for str in fmt_str:gmatch("([^<>]+)") do
    table.insert(pair_parts, str)
  end
  local lhs = pair_parts[1]
  local delete_rules = {
    get_delete_rule(
      lhs,
      concat_slice(pair_parts, 2)
    ),
  }

  for i = 2, #pair_parts - 1, 1 do
    lhs = lhs .. pair_parts[i]
    table.insert(delete_rules,
      get_delete_rule(
        lhs,
        concat_slice(pair_parts, i + 1)
      )
    )
  end

  return delete_rules
end


---------- Module ------------

local M = {}


M.get_latex_deletion_rules = function()
  local deletion_rules = {}
  for _, symbol in ipairs(latex_deletion_symbols) do
    for _, rule in ipairs(fmt_angle_to_pair_delete_rules(symbol)) do
      table.insert(deletion_rules, rule)
    end
  end

  return deletion_rules
end

return M

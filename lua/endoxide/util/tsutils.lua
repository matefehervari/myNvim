-- https://github.com/frankroeder/dotfiles/nvim/lua/plugins/tsutils.lua - modified*

local has_treesitter, ts = pcall(require, "vim.treesitter")

local M = {}

local MATH_ENVIRONMENTS = {
  displaymath = true,
  equation = true,
  eqnarray = true,
  align = true,
  math = true,
  array = true,
  alignat = true,
}

local MATH_NODES = {
  displayed_equation = true,
  inline_formula = true,
}

local function get_node_at_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_range = { cursor[1] - 1, cursor[2] }
  local parser = ts.get_parser(0)
  local root_tree = parser:parse()[1]
  local root = root_tree and root_tree:root()

  if not root then
    return
  end

  return root:named_descendant_for_range(
    cursor_range[1],
    cursor_range[2],
    cursor_range[1],
    cursor_range[2]
  )
end

function M.in_comment()
  if has_treesitter then
    local node = get_node_at_cursor()
    while node do
      if node:type() == "comment" then
        return true
      end
      node = node:parent()
    end
    return false
  end
end

-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1184#issuecomment-830388856
function M.in_mathzone()
  if has_treesitter then
    local buf = vim.api.nvim_get_current_buf()
    local node = get_node_at_cursor()
    while node do
      if node:type() == "ERROR" then
        -- Some nodes such as subscripting may cause parse errors. Fallback to previous mathzone state in that case.
        return vim.g.prev_tex_in_math_zone
      elseif MATH_NODES[node:type()] then
        return true
      elseif node:type() == "text_mode" then -- \text{} inside mathzone sohuld be treated as text
        return false
      elseif node:type() == "math_environment" or node:type() == "generic_environment" then
        local begin = node:child(0)
        local names = begin and begin:field("name")
        if
          names
          and names[1]
          and MATH_ENVIRONMENTS[ts.get_node_text(names[1], buf):match "[A-Za-z]+"]
        then
          return true
        end
      end
      node = node:parent()
    end
    return false
  end
end

return M

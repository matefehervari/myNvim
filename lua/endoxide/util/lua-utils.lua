local M = {}

M.insert_all = function(a, b)
    for _, elem in ipairs(b) do
        table.insert(a, elem)
    end
end

M.has_value = function(tbl, val)
    for idx = 1, #tbl do
        -- We grab the first index of our sub-table instead
        if tbl[idx] == val then
            return true
        end
    end

    return false
end

M.find = function(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return i end
    end
    return nil
end

M.get_visual_region = function()
  local mode = vim.fn.mode()
  local is_visual = mode:match("v")
  local is_linevisual = mode:match("V")

  if not is_visual and not is_linevisual then
      return
  end

  local s_pos = vim.fn.getpos("v")
  local e_pos = vim.fn.getpos(".")
  local sl, sc = s_pos[2], s_pos[3]
  local el, ec = e_pos[2], e_pos[3]
  -- normalize order
  if sl > el or (sl == el and sc > ec) then
    sl, el = el, sl
    sc, ec = ec, sc
  end
  -- get all lines
  local lines = vim.api.nvim_buf_get_lines(0, sl - 1, el, false)
  -- trim start and end columns
  if is_visual then
      lines[1]  = string.sub(lines[1], sc)
      lines[#lines] = string.sub(lines[#lines], 1, ec)
  end
  return lines, sl, el
end

return M

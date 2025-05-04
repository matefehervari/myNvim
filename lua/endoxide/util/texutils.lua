local function in_env(name)
    return function ()
      local is_inside = vim.fn['vimtex#env#is_inside'](name)
      -- perhaps using both tests is redundant and only the is_inside[1] is needed?
      return (is_inside[1] > 0 and is_inside[2] > 0)
    end
end

local function not_in_env(name)
    return function ()
      local is_inside = vim.fn['vimtex#env#is_inside'](name)
      return not (is_inside[1] > 0 and is_inside[2] > 0)
    end
end

local inside = {}
inside.tikz = in_env("tikzpicture")
inside.enum = in_env("enumerate")
inside.item = in_env("itemize")
inside.lstlisting = in_env("lstlisting")
inside.lstinline = in_env("lstinline")
inside.prooftree = in_env("prooftree")
inside.comment = function ()
    return vim.fn["vimtex#syntax#in_comment"]() == 1
end

local isnot = {}
local not_inside = {}

not_inside.tikz = not_in_env("tikzpicture")
not_inside.enum = not_in_env("enumerate")
not_inside.item = not_in_env("itemize")
not_inside.lstlisting = not_in_env("lstlisting")
not_inside.lstinline = not_in_env("lstinline")
inside.prooftree = not_in_env("prooftree")
not_inside.comment = function ()
    return vim.fn["vimtex#syntax#in_comment"]() == 0
end

isnot.inside = not_inside

local M = {}
M.inside = inside
M.isnot = isnot

return M

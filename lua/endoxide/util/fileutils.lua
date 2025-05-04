local status_ok, setup = pcall(require, "jdtls.setup")

local titlecase = function (str)
    return str:gsub("^(%a)([%w*])", function (first, rest)
        return first:upper() .. rest:lower()
    end)
end


M = {}
if status_ok then
    M.find_root = setup.find_root
end
M.titlecase = titlecase

return M

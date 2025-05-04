local function insert_all(a, b)
    for _, elem in ipairs(b) do
        table.insert(a, elem)
    end
end

local function has_value(tbl, val)
    for idx = 1, #tbl do
        -- We grab the first index of our sub-table instead
        if tbl[idx] == val then
            return true
        end
    end

    return false
end

local function find(tbl, val)
    for i, v in ipairs(tbl) do
        if v == val then return i end
    end
    return nil
end

local M = {}
M.insert_all = insert_all
M.has_value = has_value
M.find = find

return M

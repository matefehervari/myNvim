local status_ok, setup = pcall(require, "jdtls.setup")

M = {}

M.titlecase = function(str)
    return str:gsub("^(%a)([%w*])", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

M.find_ignore_file = function(start_dir, filename)
    local dir = start_dir or vim.fn.getcwd()
    while dir do
        local candidate = dir .. "/" .. filename
        if vim.fn.filereadable(candidate) == 1 then
            return candidate
        end
        local parent = vim.fn.fnamemodify(dir, ":h")
        if parent == dir then
            break
        end
        dir = parent
    end
    return nil
end

M.read_ignore_patterns = function(filepath)
    local patterns = {}
    if filepath then
        for line in io.lines(filepath) do
            local trimmed = vim.trim(line)
            if trimmed ~= "" and not trimmed:match("^#") then
                table.insert(patterns, trimmed)
            end
        end
    end
    return patterns
end

function getparent(path)
    return vim.fn.fnamemodify(path, ":h")
end

M.find_root = function(fname, markers)
    fname = fname or vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
    local dirname = vim.fn.fnamemodify(fname, ':p:h')
    while getparent(dirname) ~= dirname do
        for _, marker in ipairs(markers) do
            local files = vim.fn.globpath(dirname, marker, false, true)
            if #files > 0 then
                return dirname
            end
            -- if uv.fs_stat(require("jdtls.path").join(dirname, marker)) then
            --     return dirname
            -- end
        end
        dirname = getparent(dirname)
    end
end


-- if status_ok then
--     M.find_root = setup.find_root
-- end

return M

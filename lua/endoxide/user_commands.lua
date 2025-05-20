local lua_utils = require("endoxide.util.lua-utils")

vim.api.nvim_create_user_command('DuplicateWithReplace', function() -- opts
    local mode = vim.fn.mode()
    local is_visual = mode:match("[vV]")
    local is_normal = mode:match("n")

    local target = vim.fn.input("Pattern to replace")
    if target == "" then
        return
    end

    local replacements = {}
    while true do
        local repl = vim.fn.input("Replacement (Press Enter to stop)")
        if repl == "" then break end
        table.insert(replacements, repl)
    end

    if #replacements == 0 then
        return
    end

    local lines
    if is_normal then
        lines = {vim.api.nvim_get_current_line()}
    elseif is_visual then
        lines = lua_utils.get_visual_region()
        if lines == nil then
            return
        end
    else
        return
    end
    for _, repl in ipairs(replacements) do
        for _, line in ipairs(lines) do
            local new_line = line:gsub(target, repl)
            vim.api.nvim_put({ new_line }, "l", true, false)
        end
    end
end, {})

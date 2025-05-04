vim.api.nvim_create_user_command('DuplicateWithReplace', function() -- opts
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

    local line = vim.api.nvim_get_current_line()
    for _, repl in ipairs(replacements) do
        local new_line = line:gsub(target, repl)
        vim.api.nvim_put({ new_line }, "l", true, false)
    end
end, {})

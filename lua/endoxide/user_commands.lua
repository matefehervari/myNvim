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
        lines = { vim.api.nvim_get_current_line() }
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

vim.api.nvim_create_user_command('DuplicateLine', function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local line = vim.api.nvim_get_current_line()
    vim.api.nvim_buf_set_lines(0, row, row, true, { line })
    vim.api.nvim_win_set_cursor(0, { row + 1, col })
end, {})

vim.api.nvim_create_user_command('DuplicateLines', function()
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")

    local start_line = start_pos[2] - 1
    local end_line = end_pos[2]

    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line, true)
    vim.api.nvim_buf_set_lines(0, end_line, end_line, true, lines)
    vim.cmd("normal! gv")
end, {})

local Remap = require("endoxide.keymap")

local nnoremap = Remap.nnoremap

local utils = require("endoxide.util.lua-utils")

nnoremap("<S-l>", function()
    local current = vim.fn.bufnr()
    local buffers = vim.g.endoxide.bufferspinned
    for _, buf in ipairs(vim.g.endoxide.buffers) do
        table.insert(buffers, buf)
    end

    local index
    for i, value in ipairs(buffers) do
        if value == current then
            index = i
            break
        end
    end

    if index == #buffers then
        vim.api.nvim_set_current_buf(buffers[1])
    else
        vim.api.nvim_set_current_buf(buffers[index + 1])
    end
end, {desc="Buffers move right"})

nnoremap("<S-h>", function()
    local current = vim.fn.bufnr()
    local buffers = vim.g.endoxide.bufferspinned
    for _, buf in ipairs(vim.g.endoxide.buffers) do
        table.insert(buffers, buf)
    end

    local index
    for i, value in ipairs(buffers) do
        if value == current then
            index = i
            break
        end
    end

    if index == 1 then
        vim.api.nvim_set_current_buf(buffers[#buffers])
    else
        vim.api.nvim_set_current_buf(buffers[index - 1])
    end
end, {desc="Buffers move left"})

nnoremap("<C-q>", function()
    local buffers = vim.g.endoxide.buffers
    for _, buf in pairs(vim.g.endoxide.bufferspinned) do
        table.insert(buffers, buf)
    end

    local windows = {}
    for _, win in pairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if utils.has_value(buffers, buf) then
            table.insert(windows, win)
        end
    end


    if #windows == 1 then
        vim.api.nvim_buf_delete(0, { force = false, unload = false })
    else
        vim.api.nvim_win_close(0, false)
    end
end, {desc="Buffers delete"})

nnoremap("<leader>h", function()
    local current = vim.fn.bufnr()
    local buffers = vim.g.endoxide.buffers
    local bufferspinned = vim.g.endoxide.bufferspinned

    local index
    for i, value in ipairs(buffers) do
        if value == current then
            index = i
            break
        end
    end

    if index ~= nil then
        table.remove(buffers, index)
        if index == 1 then
            if #bufferspinned == 0 then
                table.insert(buffers, current)
            else
                table.insert(bufferspinned, #bufferspinned, current)
            end
        else
            table.insert(buffers, index - 1, current)
        end
        goto last
    end

    for i, value in ipairs(bufferspinned) do
        if value == current then
            index = i
            break
        end
    end

    if index ~= 1 then
        table.remove(bufferspinned, index)
        table.insert(bufferspinned, index - 1, current)
    end

    ::last::
    vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = bufferspinned }, vim.g.endoxide)
    require("lualine").refresh()
end, {desc="Rearrange buffer leftwards"})

nnoremap("<leader>l", function()
    local current = vim.fn.bufnr()
    local buffers = vim.g.endoxide.buffers
    local bufferspinned = vim.g.endoxide.bufferspinned

    local index
    for i, value in ipairs(buffers) do
        if value == current then
            index = i
            break
        end
    end

    if index ~= nil then
        local n = #buffers

        table.remove(buffers, index)
        if index == n then
            table.insert(buffers, 1, current)
        else
            table.insert(buffers, index + 1, current)
        end
        goto last
    end

    for i, value in ipairs(bufferspinned) do
        if value == current then
            index = i
            break
        end
    end

    if index < #bufferspinned then
        table.remove(bufferspinned, index)
        table.insert(bufferspinned, index + 1, current)
    end

    ::last::
    vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = bufferspinned }, vim.g.endoxide)
    require("lualine").refresh()
end, {desc="Rearrange buffer rightwards"})

nnoremap("<C-p>", function()
    local current = vim.fn.bufnr()
    local buffers = vim.g.endoxide.buffers
    local bufferspinned = vim.g.endoxide.bufferspinned

    local index
    for i, value in ipairs(buffers) do
        if value == current then
            index = i
            break
        end
    end

    if index ~= nil then
        table.insert(bufferspinned, current)
        table.remove(buffers, index)
        goto last
    end

    for i, value in ipairs(bufferspinned) do
        if value == current then
            index = i
            break
        end
    end

    table.remove(bufferspinned, index)
    table.insert(buffers, 1, current)

    ::last::
    vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = bufferspinned }, vim.g.endoxide)
    require("lualine").refresh()
end, {desc="Pin buffer"})

nnoremap(
    "<leader>qa",
    function()
        local current = vim.fn.bufnr()
        local buffers = vim.g.endoxide.buffers

        for _, bufnr in ipairs(buffers) do
            if bufnr ~= current then
                vim.api.nvim_buf_delete(bufnr, { force = false, unload = false })
            end
        end
    end,
    { desc = "Delete all other buffers" }
)

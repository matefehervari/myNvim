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
end, { desc = "Buffers move right" })

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
end, { desc = "Buffers move left" })

nnoremap("<C-q>", function()
    local buffers = vim.g.endoxide.buffers
    local bufferspinned = vim.g.endoxide.bufferspinned
    local all_buffers = vim.list_extend(buffers, bufferspinned)

    -- filter windows with open buffers
    local windows = vim.tbl_filter(
        function(win)
            local win_buf = vim.api.nvim_win_get_buf(win)
            return vim.list_contains(all_buffers, win_buf)
        end,
        vim.api.nvim_list_wins()
    )

    if #windows == 1 then -- delete buffer
        local buf = vim.api.nvim_get_current_buf()
        local p_idx = utils.find(bufferspinned)
        local b_idx = utils.find(buffers)
        local idx = p_idx or b_idx
        local remove_target = (p_idx == nil and buffers) or (b_idx == nil and bufferspinned) or nil
        assert(remove_target ~= nil, "Error: Current buffer not in tracked buffers")

        if #remove_target == idx and idx > 1 then
            vim.cmd("b " .. (all_buffers[idx - 1]))
            table.remove(remove_target, idx)
            vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = bufferspinned }, vim.g.endoxide)
        end

        vim.api.nvim_buf_delete(buf, { force = false, unload = false })
    else -- close window instead
        vim.api.nvim_win_close(0, false)
    end
end, { desc = "Buffers delete" })

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
end, { desc = "Rearrange buffer leftwards" })

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
end, { desc = "Rearrange buffer rightwards" })

nnoremap("<C-p>", function()
    local current = vim.api.nvim_get_current_buf()
    local buffers = vim.g.endoxide.buffers
    local bufferspinned = vim.g.endoxide.bufferspinned

    local idx = utils.find(buffers, current)

    if idx ~= nil then
        table.insert(bufferspinned, current)
        table.remove(buffers, idx)
    else
        idx = utils.find(bufferspinned, current)
        table.insert(buffers, 1, current)
        table.remove(bufferspinned, idx)
    end

    vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = bufferspinned }, vim.g.endoxide)
    require("lualine").refresh()
end, { desc = "Pin buffer" })

nnoremap(
    "<leader>qa",
    function()
        local current = vim.api.nvim_get_current_buf()
        local buffers = vim.g.endoxide.buffers
        vim.g.endoxide = vim.tbl_extend('keep', { buffers = { current } }, vim.g.endoxide)

        for _, bufnr in ipairs(buffers) do
            if bufnr ~= current then
                vim.api.nvim_buf_delete(bufnr, { force = false, unload = false })
            end
        end
    end,
    { desc = "Delete all other buffers" }
)

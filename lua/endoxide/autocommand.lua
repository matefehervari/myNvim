local tsutils = require("endoxide.util.tsutils")

local augroup = vim.api.nvim_create_augroup
local endoxideGroup = augroup('endoxide', {})
local autocmd = vim.api.nvim_create_autocmd
local nnoremap = require("endoxide.keymap").nnoremap

local function setup_buffers()
    -- Buffer info
    autocmd({ "BufRead", "BufEnter", "BufDelete", "SessionLoadPost" }, {
        group = endoxideGroup,
        callback = function()
            -- get listed buffers known by nvim
            local buffers_listed = vim.tbl_map(function(bufinfo)
                    return bufinfo.bufnr
                end,
                vim.fn.getbufinfo({ buflisted = 1 })
            )
            -- print("buffers_listed: " .. vim.inspect(buffers_listed))

            -- get tracked buffers which are still listed
            local buffers = vim.tbl_filter(function(bufnr)
                    return vim.tbl_contains(buffers_listed, bufnr)
                end,
                vim.g.endoxide.buffers
            )

            -- get tacked pinned buffers which are still listed
            local bufferspinned = vim.tbl_filter(function(bufnr)
                    return vim.tbl_contains(buffers_listed, bufnr)
                end,
                vim.g.endoxide.bufferspinned
            )

            -- add untracked listed buffers
            for _, bufnr in ipairs(buffers_listed) do
                if not vim.tbl_contains(buffers, bufnr) and not vim.tbl_contains(bufferspinned, bufnr) then
                    table.insert(buffers, bufnr)
                end
            end


            -- print("buffers_listed : " .. vim.inspect(buffers_listed))
            -- print("vim.g.endoxide.buffers before: " .. vim.inspect(vim.g.endoxide.buffers))
            -- print("buffers: " .. vim.inspect(buffers))
            vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = bufferspinned }, vim.g.endoxide)
            -- print("vim.g.endoxide.buffers after: " .. vim.inspect(vim.g.endoxide.buffers))
        end,
    })

    -- Buffer info
    autocmd(
        { "BufRead", "BufEnter", "BufDelete", "SessionLoadPost", "TextChanged", "TextChangedI",
            "CursorMoved", "RecordingEnter", "BufWritePost" },
        {
            group = endoxideGroup,
            callback = function()
                local status_ok, lualine = pcall(require, "lualine")
                if status_ok then
                    lualine.refresh()
                end
            end,
        })
end

-- General setup
local function setup()
    -- latex spell checking
    autocmd({ "BufRead" }, {
        group = endoxideGroup,
        pattern = "*.tex",
        callback = function()
            vim.cmd(":setlocal spell spelllang=en")
        end
    })

    -- latex math zone detection
    autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = endoxideGroup,
        pattern = "*.tex",
        callback = function()
            vim.g.prev_tex_in_math_zone = vim.g.tex_in_math_zone
            vim.g.tex_in_math_zone = tsutils.in_mathzone()
        end
    })

    autocmd({ "BufRead" }, {
        group = endoxideGroup,
        pattern = "*.pro",
        callback = function()
            vim.cmd(":set filetype=prolog")
        end,
    })

    autocmd({ "BufRead" }, {
        group = endoxideGroup,
        pattern = "*.rasi",
        callback = function()
            vim.cmd(":set filetype=rasi")
        end,
    })
    autocmd({ "BufRead" }, {
        group = endoxideGroup,
        pattern = "*.bsv",
        callback = function()
            vim.cmd(":set commentstring=//%s")
        end,
    })

    autocmd("TextYankPost", {
        desc = "Highlight when yanking text",
        group = endoxideGroup,
        callback = function()
            vim.highlight.on_yank()
        end
    })

    autocmd({ "FileType", }, {
        desc = "Map ESC to exit checkhealth",
        group = endoxideGroup,
        pattern = "checkhealth",
        callback = function()
            nnoremap("<ESC>", function()
                vim.api.nvim_win_close(0, true)
            end, { buffer = 0 })
        end
    })

    setup_buffers()
end

local M = {}
M.augroup = augroup
M.endoxideGroup = endoxideGroup
M.autocmd = autocmd
M.setup = setup

return M

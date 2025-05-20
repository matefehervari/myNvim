local tsutils = require("endoxide.util.tsutils")
local nnoremap = require("endoxide.keymap").nnoremap

local augroup = vim.api.nvim_create_augroup
local endoxideGroup = augroup('endoxide', {})
local autocmd = vim.api.nvim_create_autocmd

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

    autocmd("LspAttach", {
        group = endoxideGroup,
        callback = function()
            vim.lsp.inlay_hint.enable()

            nnoremap("yok", function()
                local enabled = not vim.lsp.inlay_hint.is_enabled({})
                vim.lsp.inlay_hint.enable(enabled)
                vim.notify("Inlay hints: " .. (enabled and " on" or "off"), nil, { title = "Inlay Hints Toggled" })
            end, { buffer = 0, desc = "Toggle inlay hints" })
        end
    })

    -- Buffer info
    autocmd({ "BufRead", "BufEnter", "BufDelete", "SessionLoadPost" }, {
        group = endoxideGroup,
        callback = function()
            local buffers_listed = vim.tbl_map(function(bufinfo)
                    return bufinfo.bufnr
                end,
                vim.fn.getbufinfo({ buflisted = 1 })
            )

            local buffers = vim.tbl_filter(function(bufnr)
                    return vim.tbl_contains(buffers_listed, bufnr)
                end,
                vim.g.endoxide.buffers
            )

            local bufferspinned = vim.tbl_filter(function(bufnr)
                    return vim.tbl_contains(buffers_listed, bufnr)
                end,
                vim.g.endoxide.bufferspinned
            )

            for _, bufnr in ipairs(buffers_listed) do
                if not vim.tbl_contains(buffers, bufnr) and not vim.tbl_contains(bufferspinned, bufnr) then
                    table.insert(buffers, bufnr)
                end
            end

            vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = bufferspinned }, vim.g.endoxide)
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

    -- Deferred updates
    autocmd(
        { "RecordingLeave", "ModeChanged", "BufWritePost" },
        {
            group = endoxideGroup,
            callback = function()
                local status_ok, lualine = pcall(require, "lualine")
                if not status_ok then
                    return
                end

                local timer = vim.uv.new_timer()
                if timer then
                    timer:start(50, 0, vim.schedule_wrap(lualine.refresh))
                end
            end,
        })

    autocmd("TextYankPost", {
        desc = "Highlight when yanking text",
        group = endoxideGroup,
        callback = function()
            vim.highlight.on_yank()
        end
    })
end

local M = {}
M.augroup = augroup
M.endoxideGroup = endoxideGroup
M.autocmd = autocmd
M.setup = setup

return M

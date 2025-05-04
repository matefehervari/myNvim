return {
    "rmagatti/goto-preview",
    dependencies = { "rmagatti/logger.nvim" },
    event = "BufEnter",
    config = function()
        local goto_preview = require("goto-preview")
        local nnoremap = require("endoxide.keymap").nnoremap
        local find = require("endoxide.util.lua-utils").find

        local function is_preview(win)
            local buf = vim.api.nvim_win_get_buf(win)
            local preview_windows = vim.b[buf].preview_windows or {}
            return find(preview_windows, win) ~= nil
        end

        local config = {
            width = 120,                                         -- Width of the floating window
            height = 15,                                         -- Height of the floating window
            border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }, -- Border characters of the floating window
            default_mappings = false,                            -- Bind default mappings
            debug = false,                                       -- Print debug information
            opacity = nil,                                       -- 0-100 opacity level of the floating window where 100 is fully transparent.
            resizing_mappings = false,                           -- Binds arrow keys to resizing the floating window.
            post_open_hook = function(buf, win)
                local preview_windows = vim.b[buf].preview_windows or {}
                if not find(preview_windows, win) then
                    table.insert(preview_windows, win)
                end
                vim.b[buf].preview_windows = preview_windows

                nnoremap("<Esc>", function()
                    local curr_win = vim.api.nvim_get_current_win()
                    if is_preview(curr_win) then
                        vim.api.nvim_win_close(curr_win, true)
                    end
                end, { buffer = buf })

                nnoremap("<CR>", function()
                    local curr_win = vim.api.nvim_get_current_win()
                    local pos = vim.api.nvim_win_get_cursor(curr_win)
                    if is_preview(curr_win) then
                        goto_preview.close_all_win()
                        vim.api.nvim_set_current_buf(buf)
                        vim.api.nvim_win_set_cursor(0, pos)
                    end
                end, { buffer = buf })
            end, -- A function taking two arguments, a buffer and a window to be ran as a hook.
            post_close_hook = function(buf, win)
                local win_config = vim.api.nvim_win_get_config(win)
                local pwin = win_config.win
                local preview_windows = vim.b[buf].preview_windows or {}
                local preview_idx = find(preview_windows, win)
                if preview_idx then
                    table.remove(preview_windows, preview_idx)
                    vim.b[buf].preview_windows = preview_windows
                end
                if pwin == nil then
                    pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<Esc>")
                    pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<CR>")
                    return
                end

                local pwin_config = vim.api.nvim_win_get_config(pwin)
                if pwin_config.win == nil then
                    pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<Esc>")
                    pcall(vim.api.nvim_buf_del_keymap, buf, "n", "<CR>")
                end
            end,                        -- A function taking two arguments, a buffer and a window to be ran as a hook.
            references = {              -- Configure the telescope UI for slowing the references cycling window.
                provider = "telescope", -- telescope|fzf_lua|snacks|mini_pick|default
                telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
            },
            -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
            focus_on_open = true,                                        -- Focus the floating window when opening it.
            dismiss_on_move = false,                                     -- Dismiss the floating window when moving the cursor.
            force_close = true,                                          -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
            bufhidden = "wipe",                                          -- the bufhidden option to set on the floating window. See :h bufhidden
            stack_floating_preview_windows = true,                       -- Whether to nest floating windows
            same_file_float_preview = true,                              -- Whether to open a new floating window for a reference within the current file
            preview_window_title = { enable = true, position = "left" }, -- Whether to set the preview window title as the filename
            zindex = 1,                                                  -- Starting zindex for the stack of floating windows
            vim_ui_input = false,                                         -- Whether to override vim.ui.input with a goto-preview floating window
        }

        goto_preview.setup(config)

        -- Keymaps
        nnoremap("gpd", goto_preview.goto_preview_definition)
        nnoremap("gpt", goto_preview.goto_preview_type_definition)
        nnoremap("gpi", goto_preview.goto_preview_implementation)
        nnoremap("gpD", goto_preview.goto_preview_declaration)
        nnoremap("gP",  goto_preview.close_all_win)
        nnoremap("gpr", goto_preview.goto_preview_references)
    end
}

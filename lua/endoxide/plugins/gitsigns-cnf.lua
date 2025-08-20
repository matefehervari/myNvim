return {
    "lewis6991/gitsigns.nvim",
    enabled = false,
    config = function()
        local keymaps = require("endoxide.keymap")
        local map = keymaps.noremap
        local nnoremap = keymaps.nnoremap
        local vnoremap = keymaps.vnoremap

        local config = {
            signs                        = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signs_staged                 = {
                add          = { text = '│' },
                change       = { text = '│' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signs_staged_enable          = true,
            signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
            numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
            linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
            word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
            watch_gitdir                 = {
                follow_files = true
            },
            auto_attach                  = true,
            attach_to_untracked          = false,
            current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
            current_line_blame_opts      = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 1000,
                ignore_whitespace = false,
                virt_text_priority = 100,
                use_focus = true,
            },
            current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
            sign_priority                = 6,
            update_debounce              = 100,
            status_formatter             = nil,   -- Use default
            max_file_length              = 40000, -- Disable if file is longer than this (in lines)
            preview_config               = {
                -- Options passed to nvim_open_win
                border = 'single',
                style = 'minimal',
                relative = 'cursor',
                row = 0,
                col = 1
            },

            on_attach                    = function(_) -- bufnr
                local gitsigns = require('gitsigns')

                -- Navigation
                nnoremap(']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ ']c', bang = true })
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, { desc = "GitSigns go to next hunk" })

                nnoremap('[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({ '[c', bang = true })
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, { desc = "GitSigns go to previous hunk" })

                -- Actions
                nnoremap('<leader>gs', gitsigns.stage_hunk, { desc = "GitSigns stage hunk" })
                nnoremap('<leader>gr', gitsigns.reset_hunk, { desc = "GitSigns reset hunk" })
                vnoremap('<leader>gs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "GitSigns stage hunk visual" })
                vnoremap('<leader>gr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { desc = "GitSigns reset hunk visual" })
                nnoremap('<leader>gS', gitsigns.stage_buffer, { desc = "GitSigns stage buffer" })
                nnoremap('<leader>gu', gitsigns.undo_stage_hunk, { desc = "GitSigns undo stage hunk" })
                nnoremap('<leader>gR', gitsigns.reset_buffer, { desc = "GitSigns reset buffer" })
                nnoremap('<leader>gp', gitsigns.preview_hunk, { desc = "GitSigns preview hunk changes" })
                nnoremap('<leader>gb', function() gitsigns.blame_line { full = true } end,
                    { desc = "GitSigns show full git blame" })
                -- nnoremap('<leader>tb', gitsigns.toggle_current_line_blame)
                nnoremap('<leader>gd', gitsigns.diffthis, { desc = "GitSigns diffthis" })
                nnoremap('<leader>td', gitsigns.toggle_deleted, { desc = "GitSigns toggle deleted line" })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }

        require('gitsigns').setup(config)
    end
}

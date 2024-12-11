return {
  "https://github.com/lewis6991/gitsigns.nvim",
  config = function()
    local keymaps = require("endoxide.keymap")
    local map = keymaps.noremap
    local nnoremap = keymaps.nnoremap
    local vnoremap = keymaps.vnoremap

    local config = {
      signs                        = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signs_staged                 = {
        add          = { text = '┃' },
        change       = { text = '┃' },
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

      on_attach = function(_) -- bufnr
        local gitsigns = require('gitsigns')

        -- Navigation
        nnoremap(']c', function()
          if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
          else
            gitsigns.nav_hunk('next')
          end
        end)

        nnoremap('[c', function()
          if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        nnoremap('<leader>gs', gitsigns.stage_hunk)
        nnoremap('<leader>gr', gitsigns.reset_hunk)
        vnoremap('<leader>gs', function() gitsigns.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        vnoremap('<leader>gr', function() gitsigns.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
        nnoremap('<leader>gS', gitsigns.stage_buffer)
        nnoremap('<leader>gu', gitsigns.undo_stage_hunk)
        nnoremap('<leader>gR', gitsigns.reset_buffer)
        nnoremap('<leader>gp', gitsigns.preview_hunk)
        nnoremap('<leader>gb', function() gitsigns.blame_line { full = true } end)
        -- nnoremap('<leader>tb', gitsigns.toggle_current_line_blame)
        nnoremap('<leader>gd', gitsigns.diffthis)
        nnoremap('<leader>gD', function() gitsigns.diffthis('~') end)
        nnoremap('<leader>td', gitsigns.toggle_deleted)

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
      end
    }

    require('gitsigns').setup(config)
  end
}

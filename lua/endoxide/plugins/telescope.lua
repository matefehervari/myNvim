return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Useful lua functions used ny lots of plugins
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "kyazdani42/nvim-web-devicons",
  },

  config = function ()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local config = {
      defaults = {

        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },

        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,

            ["<S-Tab>"] = actions.close,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,

            ["<CR>"] = actions.select_default,
            ["<C-s>"] = actions.select_horizontal,  -- opens in horizontal split
            ["<C-v>"] = actions.select_vertical,    -- opens in vertical split
            ["<C-t>"] = actions.select_tab,         -- opens in new tab

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<C-y>"] = actions.results_scrolling_up,
            ["<C-e>"] = actions.results_scrolling_down,

            ["<M-k>"] = actions.toggle_selection + actions.move_selection_worse,    -- multiselect up
            ["<M-j>"] = actions.toggle_selection + actions.move_selection_better,   -- multiselect down
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
          },

          n = {
            ["<S-Tab>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,

            ["<M-k>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<M-j>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,

            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,

            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,

            ["<C-y>"] = actions.results_scrolling_up,
            ["<C-e>"] = actions.results_scrolling_down,

            ["?"] = actions.which_key,
          },
        },
      },

      extensions = {
        media_files = {
            -- filetypes whitelist
            filetypes = {"png", "webp", "jpg", "jpeg", "pdf"},
            find_cmd = "rg" -- find command (defaults to `fd`)
          }
      },
    }
    telescope.setup(config)

    -- load extensions
    telescope.load_extension("fzf")
    telescope.load_extension('media_files')
    telescope.load_extension('persisted')

    -- set keymaps
    local Remap = require("endoxide.keymap")
    local nnoremap = Remap.nnoremap

    nnoremap("<leader>ff", ":Telescope find_files<cr>",
             { desc = "Fuzzy find files in cwd"})

    nnoremap("<leader>fd", ":Telescope find_files cwd=",
             { desc = "Fuzzy find files in specified directory"})

    nnoremap("<leader>fs", ":Telescope live_grep<cr>",
             { desc = "Find string in cwd" })

    nnoremap("<leader>fw", ":Telescope grep_string<cr>",
             { desc = "Find string under cursor in cwd" })

    nnoremap("<leader>fq", ":Telescope persisted<CR>",
             { desc = "Search through sessions" })
  end
}

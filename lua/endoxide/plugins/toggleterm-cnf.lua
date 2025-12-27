return {
    "akinsho/toggleterm.nvim",
    version = "*",

    config = function()
        local toggleterm = require("toggleterm")
        local Remap = require("endoxide.keymap")
        local nnoremap = Remap.nnoremap
        local autocommand = require("endoxide.autocommand")
        local autocmd = autocommand.autocmd
        local endoxideGroup = autocommand.endoxideGroup

        local config = {
            size = 80,
            ide_numbers = true,
            shade_terminals = false,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            close_on_exit = true,
            env = {
                TOGGLETERM = "1"
            },
            highlights = {
                Normal = {
                    guibg = "None",
                },
                SignColumn = {
                    guibg = "None"
                }
            },
            float_opts = {
                border = "curved",
                winblend = 0,
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
        }

        toggleterm.setup(config)

        -- functions
        local Terminal = require("toggleterm.terminal").Terminal

        local on_open  = function()
            vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', [[<cmd>close<cr>]], { noremap = true })
        end

        local node     = Terminal:new({ cmd = "node", hidden = true, direction = "float", on_open = on_open })
        local python   = Terminal:new({ cmd = "python3", hidden = true, direction = "float", on_open = on_open })
        local gitui    = Terminal:new({ cmd = "gitui", hidden = true, direction = "float", on_open = on_open })
        local swipl    = Terminal:new({ cmd = "swipl", hidden = true, direction = "float", on_open = on_open })
        local posting  = Terminal:new({ cmd = "posting", hidden = true, direction = "float", o_open = on_open })

        function _NODE_TOGGLE()
            node:toggle()
        end

        function _PYTHON_TOGGLE()
            python:toggle()
        end

        function _GITUI_TOGGLE()
            gitui:toggle()
        end

        function _SWIPL_TOGGLE()
            swipl:toggle()
        end

        function _POSTING_TOGGLE()
            posting:toggle()
        end

        local function set_terminal_keymaps()
            local opts = { noremap = true }
            vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
            vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<Esc>', "<Cmd>ToggleTermToggleAll<CR>", opts)
        end

        _G.set_terminal_keymaps = set_terminal_keymaps
        -- keymaps

        -- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

        autocmd({ "TermOpen", }, {
            group = endoxideGroup,
            pattern = "*",
            callback = set_terminal_keymaps
        })

        autocmd({ "TermOpen" }, {
            group = endoxideGroup,
            pattern = "*",
            callback = function()
                vim.wo.colorcolumn = "0"
            end
        })

        autocmd({ "FileType", }, {
            group = endoxideGroup,
            pattern = "toggleterm",
            callback = function()
                vim.wo.colorcolumn = "0"
            end
        })

        nnoremap("<leader>tt", ":ToggleTerm direction=float dir=git_dir <CR>", { desc = "ToggleTerm working directory" })
        nnoremap("<leader>tb", function()
            local buffer_dir = vim.fn.expand("%:p:h")
            local command = (":ToggleTerm direction=float dir=%s <CR>"):format(buffer_dir)
            vim.cmd(command)
        end, { desc = "ToggleTerm buffer directory" })
        nnoremap("<leader>tv", ":ToggleTerm direction=vertical<CR>", { desc = "ToggleTerm vertical terminal" })
        nnoremap("<leader>tp", _PYTHON_TOGGLE, { desc = "ToggleTerm pthon shell" })
        nnoremap("<leader>tg", _GITUI_TOGGLE, { desc = "ToggleTerm gitui" })
        nnoremap("<leader>ts", _SWIPL_TOGGLE, { desc = "ToggleTerm swipl shell" })
        nnoremap("<leader>tn", _NODE_TOGGLE, { desc = "ToggleTerm node shell" })
        nnoremap("<leader>tr", _POSTING_TOGGLE, { desc = "ToggleTerm posting TUI" })
    end
}

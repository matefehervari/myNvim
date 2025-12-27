--- @class endoxide.buffer.ReprBufferOpts
--- @field bufnr integer The buffer number to represent
--- @field pinned? boolean Whether the buffer is pinned

return {
    "nvim-lualine/lualine.nvim", -- lualine
    requires = { "folke/tokyonight.nvim", "catppuccin/nvim", "kyazdani42/nvim-web-devicons" },

    config = function()
        local lualine = require("lualine")
        local webdevicon = require("nvim-web-devicons")

        local night = require("tokyonight.colors").setup({ style = "night" })
        local mocha = require("catppuccin.palettes").get_palette("mocha")
        local colors = require("endoxide.colors").colors
        local highlights = require("endoxide.util.highlights")
        local hl_text = highlights.hl_text
        local autocommand = require("endoxide.autocommand")
        local autocmd = autocommand.autocmd
        local endoxideGroup = autocommand.endoxideGroup
        local utils = require("endoxide.util.lua-utils")

        local icons = require("endoxide.icons")
        local diag_icons = icons.diagnostics
        local ui = icons.ui


        local buffer_limit = 5

        local linecolors = {
            secondary     = mocha.surface0,
            insert        = mocha.teal,
            normal        = mocha.blue,
            replace       = mocha.red,
            visual        = mocha.yellow,
            text_dark     = colors.black,
            text_light    = mocha.text,
            text_inactive = night.fg_dark,
        }

        local mode = {
            "mode",
            separator = { left = ui.BoldRoundDividerLeft, right = ui.BoldRoundDividerRight },
            padding = 0,
        }

        local severity_to_name = {
            [vim.diagnostic.severity.ERROR] = "Error",
            [vim.diagnostic.severity.WARN]  = "Warning",
            [vim.diagnostic.severity.INFO]  = "Hint",
            [vim.diagnostic.severity.HINT]  = "Hint",
        }
        local severity_to_icon = {
            icons.diagnostics.BoldError,
            icons.diagnostics.BoldWarning,
            icons.diagnostics.Hint,
            icons.diagnostics.Hint,
        }


        --- @param opts endoxide.buffer.ReprBufferOpts
        local function repr_buffer(opts)
            local current = vim.api.nvim_get_current_buf() -- current buffer
            local buf = vim.fn.getbufinfo(opts.bufnr)[1]   -- bufinfo of buf to repr

            local filename = vim.fs.basename(buf.name)     -- full filename
            local ext = filename:match("%.(%a+)$")         -- extension
            local file = filename:gsub("%.(%a+)$", "")     -- file w/o extension

            if filename == "" then
                file = " ~ "
            elseif file == "" then
                file = "." .. ext
            end
            if not ext then
                ext = ""
            end

            -- pinned
            local pinned = ""
            if opts.pinned then
                pinned = ui.Pin
            end
            local pinned_repr = " " .. pinned

            -- icon
            local icon, icon_name = webdevicon.get_icon(filename, ext, { default = true })
            local icon_repr = hl_text(icon_name, icon)

            -- diagnostics
            local diagnostics = vim.diagnostic.count(opts.bufnr)
            local total_diagnostics = 0
            local highest_severity = nil
            for severity, count in pairs(diagnostics) do
                total_diagnostics = total_diagnostics + count

                if highest_severity == nil then
                    highest_severity = severity
                end
            end

            -- diagnostic formatting
            local diagnostic = ""
            if highest_severity ~= nil then
                diagnostic = severity_to_icon[highest_severity]
            end
            if total_diagnostics > 0 then
                diagnostic = diagnostic .. " " .. total_diagnostics
            end

            -- buf text
            local buftext = ("%s %s"):format(file, diagnostic)
            local buftext_hl

            if highest_severity ~= nil then
                buftext_hl = "Endoxide" .. severity_to_name[highest_severity]
            else
                buftext_hl = "EndoxideBuffer"
            end

            if current == opts.bufnr then
                buftext_hl = buftext_hl .. "Selected"
            end

            local buf_repr = hl_text(buftext_hl, buftext)

            -- buf modified
            local modified = ""
            if buf.changed ~= 0 then
                modified = ui.Circle .. " "
            end

            return ("%s %s%s %s"):format(pinned_repr, modified, icon_repr, buf_repr)
        end

        local function summary(num)
            return (" +%d "):format(num)
        end

        local buffers3 = {
            function()
                local current = vim.api.nvim_get_current_buf()

                -- get listed buffers known by nvim
                local buffers_listed = vim.tbl_map(function(bufinfo)
                        return bufinfo.bufnr
                    end,
                    vim.fn.getbufinfo({ buflisted = 1 })
                )

                -- get tracked buffers which are still listed
                local buffers = vim.tbl_filter(function(bufnr)
                        return vim.tbl_contains(buffers_listed, bufnr)
                    end,
                    vim.g.endoxide.buffers
                )

                -- get tracked pinned buffers which are still listed
                local pinned = vim.tbl_filter(function(bufnr)
                        return vim.tbl_contains(buffers_listed, bufnr)
                    end,
                    vim.g.endoxide.bufferspinned
                )

                -- add untracked listed buffers
                for _, bufnr in ipairs(buffers_listed) do
                    if not vim.tbl_contains(buffers, bufnr) and not vim.tbl_contains(pinned, bufnr) then
                        table.insert(buffers, bufnr)
                    end
                end

                local curr_pinned = utils.find(pinned, current) ~= nil
                vim.g.endoxide = vim.tbl_extend('keep', { buffers = buffers, bufferspinned = pinned },
                    vim.g.endoxide)

                -- local buffers = vim.g.endoxide.buffers
                local buffers_left = {}
                local buffers_right = {}
                local append_to = buffers_left

                for _, bufnr in ipairs(buffers) do
                    if bufnr == current then
                        append_to = buffers_right
                    else
                        table.insert(append_to, bufnr)
                    end
                end

                local repr = ""
                for _, bufnr in ipairs(pinned) do
                    repr = repr .. repr_buffer { bufnr = bufnr, pinned = true }
                end

                -- include current in limit if not pinned
                local remaining_limit = curr_pinned and buffer_limit or buffer_limit - 1

                -- limit buffers on left to a maximum which allows display of
                -- one right buffer if it exists
                local left_limit = remaining_limit - (#buffers_right > 0 and not curr_pinned and 1 or 0)
                local display_left = math.min(left_limit, #buffers_left)

                -- limit buffers on right to a maximum ofto remaining available buffers from limit
                local right_limit = remaining_limit - display_left
                local display_right = math.min(right_limit, #buffers_right)

                -- display remaining left_limit buffers as:
                --     case 0: ""
                --     case <=left_limit: ( buf1 buf2 )
                --     case >left_limit: ( buf1 buf2 .. +x .. bufn)
                -- all buffers will be in buffers_left if current is pinned
                if curr_pinned then
                    if #buffers_left == 0 then
                        return repr
                    end
                    local show_summary = (left_limit < #buffers_left)
                    local display_first = show_summary and (display_left - 1) or display_left
                    for i = 1, display_first do
                        repr = repr .. repr_buffer({ bufnr = buffers_left[i] })
                    end
                    if show_summary then
                        repr = repr
                            .. summary(#buffers_left - left_limit)
                            .. repr_buffer({ bufnr = buffers_left[#buffers_left] })
                    end
                else
                    -- left summary
                    if #buffers_left > left_limit then
                        repr = repr .. summary(#buffers_left - left_limit)
                    end
                    -- display left
                    for i = #buffers_left - display_left + 1, #buffers_left do
                        repr = repr .. repr_buffer { bufnr = buffers_left[i] }
                    end
                    -- display current
                    repr = repr .. repr_buffer { bufnr = current }
                    -- display right
                    for i = 1, display_right do
                        repr = repr .. repr_buffer { bufnr = buffers_right[i] }
                    end
                    -- right summary
                    if #buffers_right > right_limit then
                        repr = repr .. summary(#buffers_right - right_limit)
                    end
                end

                return repr
            end
        }

        local macro = {
            function()
                if vim.fn.reg_recording() ~= "" then
                    return "@" .. vim.fn.reg_recording()
                else
                    return ""
                end
            end
        }

        local get_active_lsp = function()
            local msg = hl_text("EndoxideLspDisconnected", "󱐋 No Lsp")
            local clients = vim.lsp.get_clients { bufnr = 0 }

            if vim.tbl_isempty(clients) then
                return msg
            end

            local client = clients[1]
            if client.name then
                return hl_text("EndoxideLspConnected", "󱘖 " .. client.name)
            end
            return msg
        end

        local diagnostics = {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
                error = diag_icons.BoldError .. " ",
                warn = diag_icons.BoldWarning .. " ",
                info = diag_icons.Hint .. " ",
            },
        }

        local diff = {
            "diff",
            separator = { right = " | " }
        }


        local filetype = {
            "filetype",
            icons_enabled = true,
        }

        local location = {
            "location",
            separator = { left = ui.BoldRoundDividerLeft },
            color = { fg = linecolors.text_light, bg = linecolors.secondary },
            padding = { left = 0, right = 1 },
        }

        -- cool function for progress
        local progress = {
            function()
                local current_line = vim.fn.line(".")
                local total_lines = vim.fn.line("$")
                local chars = { "_", "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" }
                local line_ratio = current_line / total_lines
                local index = math.ceil(line_ratio * #chars)
                return chars[index]
            end,
            separator = { right = ui.BoldRoundDividerRight },
            color = { fg = linecolors.text_dark, bg = linecolors.normal },
            padding = { left = 1, right = 0 }
        }

        local sections = {
            lualine_a = { mode },
            lualine_b = {},
            lualine_c = { buffers3 },
            lualine_x = { macro, diagnostics, diff, get_active_lsp, filetype },
            lualine_y = { location },
            lualine_z = { progress }
        }


        local inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
        }

        local theme = {
            inactive = {
                a = { fg = linecolors.text_inactive, bg = nil },
                b = { fg = linecolors.text_inactive, bg = nil },
                c = { fg = linecolors.text_inactive, bg = nil },
            },
            visual = {
                a = { fg = linecolors.text_dark, bg = linecolors.visual },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = nil, bg = nil },
            },
            replace = {
                a = { fg = linecolors.text_dark, bg = linecolors.replace },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = nil, bg = nil },
            },
            normal = {
                a = { fg = linecolors.text_dark, bg = linecolors.normal },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = nil, bg = nil },
            },
            insert = {
                a = { fg = linecolors.text_dark, bg = linecolors.insert },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = nil, bg = nil },
            },
            command = {
                a = { fg = linecolors.text_light, bg = linecolors.secondary },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = nil, bg = nil },
            },
        }

        local config = {
            options = {
                icons_enabled = true,
                theme = theme,
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    "NvimTree",
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 0,
                    tabline = 1000,
                    winbar = 1000,
                }
            },
            sections = sections,
            inactive_sections = inactive_sections,
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {}
        }

        lualine.setup(config)
        vim.o.laststatus = 3

        -- autocommands
        autocmd({ "DiagnosticChanged" }, {
            callback = function() lualine.refresh() end
        })

        -- deferred update
        autocmd(
            { "RecordingLeave", "ModeChanged", "BufWritePost" },
            {
                group = endoxideGroup,
                callback = function()
                    local timer = vim.uv.new_timer()
                    if timer then
                        timer:start(50, 0, vim.schedule_wrap(function() lualine.refresh() end))
                    end
                end,
            })
    end
}

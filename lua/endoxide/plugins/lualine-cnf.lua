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
        local autocmd = vim.api.nvim_create_autocmd
        local utils = require("endoxide.util.lua-utils")

        local icons = require("endoxide.icons")
        local diag_icons = icons.diagnostics
        local ui = icons.ui

        local lang_servers = require("endoxide.data.lang_lsps")

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

        local function repr_buffer(opts)
            local current = vim.fn.bufnr()
            local buf = vim.fn.getbufinfo(opts.bufnr)[1]

            local filename = vim.fs.basename(buf.name)
            local ext = filename:match("%.(%a+)$")
            local file = filename:gsub("%.(%a+)$", "")

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


        local buffers3 = {
            function()
                local current = vim.fn.bufnr()
                local pinned = vim.g.endoxide.bufferspinned

                local curr_pinned = utils.find(pinned, current) ~= nil

                local buffers = {}
                local buffers_left = {}
                local buffers_right = {}
                local left = true
                for _, bufnr in ipairs(vim.g.endoxide.buffers) do
                    if bufnr == current then
                        left = false
                    elseif left then
                        table.insert(buffers_left, bufnr)
                    else
                        table.insert(buffers_right, bufnr)
                    end

                    table.insert(buffers, bufnr)
                end

                local repr = ""
                for _, bufnr in ipairs(pinned) do
                    repr = repr .. repr_buffer { bufnr = bufnr, pinned = true }
                end

                local display_left = buffer_limit - (not curr_pinned and 1 or 0) -
                    (#buffers_right > 0 and not curr_pinned and 1 or 0)
                display_left = math.min(display_left, #buffers_left)

                local display_right = buffer_limit - (not curr_pinned and 1 or 0) - display_left
                display_right = math.min(display_right, #buffers_right)


                if curr_pinned then
                    for i = 1, display_left - 1 do
                        local bufnr = buffers_left[i]
                        repr = repr .. repr_buffer { bufnr = bufnr }
                    end
                end

                if #buffers_left > display_left then
                    repr = repr .. (" +%d "):format(#buffers_left - display_left)
                end

                if curr_pinned then
                    repr = repr .. repr_buffer { bufnr = buffers_left[#buffers_left] }
                end

                if not curr_pinned then
                    for i = #buffers_left - display_left + 1, #buffers_left do
                        local bufnr = buffers_left[i]
                        repr = repr .. repr_buffer { bufnr = bufnr }
                    end
                end

                if not curr_pinned then
                    repr = repr .. repr_buffer { bufnr = current }
                end

                for i = 1, display_right do
                    local bufnr = buffers_right[i]
                    repr = repr .. repr_buffer { bufnr = bufnr }
                end

                if #buffers_right > display_right then
                    repr = repr .. (" +%d "):format(#buffers_right - display_right)
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
            local buf_ft = vim.api.nvim_get_option_value("filetype", {})
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if next(clients) == nil then
                return msg
            end

            local client_name = nil
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes

                if filetypes and
                    vim.fn.index(filetypes, buf_ft) ~= -1 and
                    (
                        not client_name or (vim.fn.index(lang_servers, client_name) == -1 and
                            vim.fn.index(lang_servers, client.name) ~= -1)
                    ) then
                    client_name = client.name
                end
            end

            if client_name then
                return hl_text("EndoxideLspConnected", "󱘖 " .. client_name)
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
                c = { fg = night.gray, bg = nil },
            },
            replace = {
                a = { fg = linecolors.text_dark, bg = linecolors.replace },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = night.gray, bg = nil },
            },
            normal = {
                a = { fg = linecolors.text_dark, bg = linecolors.normal },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = nil, bg = nil },
            },
            insert = {
                a = { fg = linecolors.text_dark, bg = linecolors.insert },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = night.gray, bg = nil },
            },
            command = {
                a = { fg = linecolors.text_light, bg = linecolors.secondary },
                b = { fg = linecolors.text_light, bg = linecolors.secondary },
                c = { fg = night.gray, bg = nil },
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

        autocmd({ "DiagnosticChanged" }, {
            callback = function()
                pcall(require("lualine").refresh)
            end
        }
        )
    end
}

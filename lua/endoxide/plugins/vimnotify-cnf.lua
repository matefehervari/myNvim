return {
    "rcarriga/nvim-notify", -- Latex
    config = function()
        local notify = require("notify")
        local config = {
            background_colour = "NotifyBackground",
            fps = 30,
            icons = {
                DEBUG = "",
                ERROR = "",
                INFO = "",
                TRACE = "✎",
                WARN = ""
            },
            level = 2,
            minimum_width = 50,
            render = "default",
            stages = "fade_in_slide_out",
            time_formats = {
                notification = "%T",
                notification_history = "%FT%T"
            },
            timeout = 3000,
            top_down = true
        }

        notify.setup(config)

        vim.notify = require("notify")
    end
}

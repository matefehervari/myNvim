return {
  "windwp/nvim-ts-autotag",
  config = function()
    local ts_autotag = require("nvim-ts-autotag")

    local config = {
      opts = {
        -- Defaults
        enable_close = true,      -- Auto close tags
        enable_rename = true,     -- Auto rename pairs of tags
        enable_close_on_slash = true -- Auto close on trailing </
      },
    }

    ts_autotag.setup(config)
  end
}

return {
  "ggandor/leap.nvim",
  config = function ()
    local leap = require("leap")

    local opts = {
        safe_labels = "fnut/FNLHMUGTZ?",
        labels = "fnjklhodweimbuyvgtaqpcxz/FNJKLHODWEIMBUYVRGTAQPCXZ?",
    }

    for key, value in pairs(opts) do
        leap.opts[key] = value
    end
  end
}

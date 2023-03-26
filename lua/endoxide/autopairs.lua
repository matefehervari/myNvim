local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
  return
end
local Rule = require("nvim-autopairs.rule")
local cond = require("nvim-autopairs.conds")

npairs.setup {
  check_ts = true,
  ts_config = {
    lua = { "string", "source" },
    javascript = { "string", "template_string" },
    java = false,
  },
  disable_filetype = { "TelescopePrompt" },
  fast_wrap = {
    map = "<C-f>",
    chars = { "{", "[", "(", '"', "'", "<", "$"},
    -- pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
    offset = 0, -- Offset from pattern match
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "PmenuSel",
    highlight_grey = "LineNr",
  },
}

npairs.add_rules({Rule("$", "$", "tex")
                :with_move(cond.after_text("$"))})

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end
-- add brackets after cmp.lsp event (function and method completion)
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

return {
    'windwp/nvim-autopairs',
    event = "InsertEnter",

    config = function ()
      local npairs = require("nvim-autopairs")

      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")

      -- setup
      local config = {
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

      npairs.setup(config)

      -- rules
      local rules = {
        Rule("$", "$", "tex")
        :with_move(function(opts)
          return opts.next_char == opts.char
        end),

        Rule("\\left[", "\\right]", "tex")
        :with_move(function(opts)
          return opts.next_char == "\\right]" and opts.char == "]"
        end),

        Rule("\\left(", "\\right)", "tex")
        :with_move(function(opts)
          return opts.next_char == "\\right)" and opts.char == ")"
        end),
      }

      npairs.add_rules(rules)

      -- cmp setup
      local cmp_autopairs = require "nvim-autopairs.completion.cmp"
      local cmp_status_ok, cmp = pcall(require, "cmp")
      if not cmp_status_ok then
        print("Failed to load cmp in autopairs configuration.")
        return
      end
      -- add brackets after cmp.lsp event (function and method completion)
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  }

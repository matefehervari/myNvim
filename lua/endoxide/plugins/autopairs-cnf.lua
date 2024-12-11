return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",

  config = function()
    local npairs = require("nvim-autopairs")

    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    local tex_pairs = require("endoxide.util.tex-pairs")

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
        chars = { "{", "[", "(", '"', "'", "<", "$" },
        -- pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        pattern = [=[[%'%"%)%>%]%)%}%,%:]]=],
        offset = 0,   -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    }

    npairs.setup(config)
    table.insert(npairs.get_rules("'")[1].not_filetypes, "tex")
    table.insert(npairs.get_rules([["]])[1].not_filetypes, "tex")

    npairs.get_rules("{")[1].not_filetypes = { "tex" }

    -- rules
    local rules = {
      Rule("$", "$", "tex")
          :with_move(function(opts)
            return opts.next_char == opts.char
          end),

      Rule("(", ")", "tex")
          :with_pair(cond.not_before_text("lr"))
          :with_pair(cond.not_before_text("\\left"))
          :with_pair(cond.is_bracket_line())
          :with_move(cond.move_right())
          :with_move(cond.is_bracket_line_move()),

      Rule("[", "]", "tex")
          :with_pair(cond.not_before_text("lr"))
          :with_pair(cond.not_before_text("\\left"))
          :with_move(cond.move_right())
          :with_pair(cond.is_bracket_line())
          :with_move(cond.is_bracket_line_move()),

      Rule("{", "}", "tex")
          :with_pair(cond.not_before_text("lr"))
          :with_pair(cond.not_before_text("\\left"))
          :with_move(cond.move_right())
          :with_pair(cond.is_bracket_line())
          :with_move(cond.is_bracket_line_move()),
    }

    local deletion_rules = tex_pairs.get_latex_deletion_rules()
    for _, v in ipairs(deletion_rules) do
      table.insert(rules, v)
    end

    npairs.add_rules(rules)

    -- cmp setup
    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if not cmp_status_ok then
      print("Failed to load cmp in autopairs configuration.")
      return
    end
    -- add brackets after cmp.lsp event (function and method completion)
    cmp.event:on("confirm_done",
      cmp_autopairs.on_confirm_done({
        filetypes = {
          ["*"] = {
            ["("] = {
              kind = {
                cmp.lsp.CompletionItemKind.Function,
                cmp.lsp.CompletionItemKind.Method,
              }
            }
          }
        }
      })
    )
  end
}

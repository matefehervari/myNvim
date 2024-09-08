return {
  "lvimuser/lsp-inlayhints.nvim",
  config = function ()
    -- local inlayhints = require("lsp-inlayhints")
    -- local hl = require("endoxide.util.highlights").hl
    --
    -- -- autocmd
    -- local augroup_inlayhints = "LspAttach_inlayhints"
    -- vim.api.nvim_create_augroup(augroup_inlayhints, {})
    -- vim.api.nvim_create_autocmd("LspAttach", {
    --   group = augroup_inlayhints,
    --   callback = function (args)
    --     if not (args.data and args.data.client_id) then
    --       return
    --     end
    --
    --     local bufnr = args.buf
    --     local client = vim.lsp.get_client_by_id(args.data.client_id)
    --     inlayhints.on_attach(client, bufnr)
    --   end
    -- })
    --
    -- -- setup
    -- inlayhints.setup()
    --
    -- -- colors
  end
}

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead
return function(server_name)
  if server_name == "jdtls" then goto continue end -- server alrady checked in handlers

  local forced_opts = {
    on_attach = require("endoxide.lsp.lsp-setup").on_attach,
    capabilities = require("endoxide.lsp.lsp-setup").capabilities,
  }

  local opts = {};

  if server_name == "jsonls" then
    opts = require("endoxide.lsp.settings.jsonls")
  elseif server_name == "lua_ls" then
    opts = require("endoxide.lsp.settings.lua_ls")
  elseif server_name == "pyright" then
    opts = require("endoxide.lsp.settings.pyright")
  elseif server_name == "ocamllsp" then
    opts = require("endoxide.lsp.settings.ocaml")
  elseif server_name == "tsserver" then
    opts = require("endoxide.lsp.settings.tsserver")
  elseif server_name == "rust_analyzer" then -- let rust-tools setup lspconfig
    local rust_analyzer_opts = require("endoxide.lsp.settings.rust_analyzer")
    opts = vim.tbl_deep_extend("force", rust_analyzer_opts, forced_opts)

    local rt = require("rust-tools")
    rt.setup({ server = opts })
    goto continue
  end

  opts = vim.tbl_deep_extend("force", opts, forced_opts)

  require("lspconfig")[server_name].setup(opts)
  ::continue::
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead
return function(server_name)
  local opts = {
    on_attach = require("endoxide.lsp.lsp-setup").on_attach,
    capabilities = require("endoxide.lsp.lsp-setup").capabilities,
  }

  if server_name == "jsonls" then
    local jsonls_opts = require("endoxide.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server_name == "lua_ls" then
    local sumneko_opts = require("endoxide.lsp.settings.sumneko_lua")
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server_name == "pyright" then
    local pyright_opts = require("endoxide.lsp.settings.pyright")
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server_name == "ocamllsp" then
    local ocamllsp_opts = require("endoxide.lsp.settings.ocaml")
    opts = vim.tbl_deep_extend("force", ocamllsp_opts, opts)
  end

  if server_name == "jdtls" then goto continue end -- server alrady checked in handlers

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

  require("lspconfig")[server_name].setup(opts)
  ::continue::
end

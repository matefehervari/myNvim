local status_ok, lsp_installer = pcall(require, "nvim-lsp-installer")
if not status_ok then
  return
end

-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = require("endoxide.lsp.handlers").on_attach,
    capabilities = require("endoxide.lsp.handlers").capabilities,
  }

  if server.name == "jsonls" then
    local jsonls_opts = require("endoxide.lsp.settings.jsonls")
    opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
  end

  if server.name == "sumneko_lua" then
    local sumneko_opts = require("endoxide.lsp.settings.sumneko_lua")
    opts = vim.tbl_deep_extend("force", sumneko_opts, opts)
  end

  if server.name == "pyright" then
    local pyright_opts = require("endoxide.lsp.settings.pyright")
    opts = vim.tbl_deep_extend("force", pyright_opts, opts)
  end

  if server.name == "ocamllsp" then
    local ocamllsp_opts = require("endoxide.lsp.settings.ocaml")
    opts = vim.tbl_deep_extend("force", ocamllsp_opts, opts)
  end

  if server.name == "jdtls" then goto continue end -- server alrady checked in handlers

  -- This setup() function is exactly the same as lspconfig's setup function.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
  ::continue::
end)

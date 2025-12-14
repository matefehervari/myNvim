local util = require("lspconfig/util")

return {
  root_dir = util.root_pattern("Cargo.toml"),
  filetypes = {"rust"},
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
}

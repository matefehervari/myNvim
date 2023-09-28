vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.cmdheight = 2 -- more space in the neovim command line for displaying messages
vim.opt_global.expandtab = true

local status, jdtls = pcall(require, "jdtls")
if not status then
  return
end

-- -- Determine OS
local home = os.getenv "HOME"
-- if vim.fn.has "mac" == 1 then
--   WORKSPACE_PATH = home .. "/workspace/"
--   CONFIG = "mac"
-- elseif vim.fn.has "unix" == 1 then
--   WORKSPACE_PATH = home .. "/workspace/"
--   CONFIG = "linux"
-- else
--   print "Unsupported system"
-- end
WORKSPACE_PATH = home .. "/Atom/Java/workspace/"
CONFIG = "linux"

-- Find root of project
local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
-- print(root_dir)
if root_dir == "" then
  return
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
-- print(project_name)

local workspace_dir = WORKSPACE_PATH .. project_name

vim.cmd("lcd " .. root_dir)

JAVA_DAP_ACTIVE = true

local bundles = {
  vim.fn.glob(
    home .. "/.config/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
  ),
}

-- vim.list_extend(bundles, vim.split(vim.fn.glob(home .. "/.config/nvim/vscode-java-test/server/*.jar"), "\n"))

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    'java', -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    "-jar",
    vim.fn.glob(home .. "/.local/share/nvim/lsp_servers/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version


    -- 💀
    "-configuration",
    home .. "/.local/share/nvim/lsp_servers/jdtls/config_" .. CONFIG,
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.


    -- 💀
    -- See `data directory configuration` section in the README
    "-data",
    workspace_dir,
  },

  -- on_attach = function(client, bufnr)
  --   require("jdtls").setup_dap({hotcodereplace = "auto"})
  -- end,
  on_attach = require("endoxide.lsp.lsp-setup").on_attach,
  capabilities = require("endoxide.lsp.lsp-setup").capabilities,

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      signatureHelp = { enabled = true },
      completion = {
        favouriteStaticMembers = {
          "java.awt.*",
          "org.junit.jupiter.api.Assertions.*"
        },
        filteredTypes = {
          "com.sun.*",
          "sun.*",
          "jdk.*",
          "org.graalvm.*",
          "io.micrometer.shaded.*"
        },
      }
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles,
  },
}


vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.java" },
  callback = function()
    vim.lsp.codelens.refresh()
  end,
})

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)

vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
vim.cmd "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)"
vim.cmd "command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()"
vim.cmd "command! -buffer JdtBytecode lua require('jdtls').javap()"

local Remap = require("endoxide.keymap")
local nnoremap = Remap.nnoremap
local vnoremap = Remap.vnoremap

nnoremap("<leader>jo", "<Cmd>lua require'jdtls'.organize_imports()<CR>")
nnoremap("<leader>jv", "<Cmd>lua require('jdtls').extract_variable()<CR>")
nnoremap("<leader>jc", "<Cmd>lua require('jdtls').extract_constant()<CR>")
nnoremap("<leader>jt", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>")
nnoremap("<leader>jT", "<Cmd>lua require'jdtls'.test_class()<CR>")
nnoremap("<leader>ju", "<Cmd>JdtUpdateConfig<CR>")
nnoremap("K", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")

vnoremap("<leader>jv", "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>")
vnoremap("<leader>jc", "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>")
vnoremap("<leader>jm", "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>")

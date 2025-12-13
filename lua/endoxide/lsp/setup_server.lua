-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead

local function get_python_venv(workspace)
    -- Check for venv in workspace root
    if vim.fn.isdirectory(workspace .. "/.venv") == 1 then
        return workspace, ".venv"
    elseif vim.fn.isdirectory(workspace .. "/venv") == 1 then
        return workspace, "venv"
    end
    -- Fallback to Poetry
    local poetry_venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    if vim.v.shell_error == 0 then
        local venv = vim.fs.basename(poetry_venv)
        local venv_path = vim.fs.dirname(poetry_venv)
        return venv_path, venv
    end
    -- Fallback to system
    return nil
end

return function(server_name)
    if
        server_name == "jdtls"
    then
        return
    end

    local forced_opts = {
        on_attach = require("endoxide.lsp.lsp-onattach").on_attach,
        capabilities = require("endoxide.lsp.lsp-onattach").capabilities,
    }

    local opts = {};

    if server_name == "jsonls" then
        opts = require("endoxide.lsp.settings.jsonls")
    elseif server_name == "lua_ls" then
        opts = require("endoxide.lsp.settings.lua_ls")
    elseif server_name == "pyright" or server_name == "basedpyright" or server_name == "pyrefly" then
        opts = require("endoxide.lsp.settings.pyright")
        opts.before_init = function(_, config)
            local venv_path, venv = get_python_venv(config.root_dir)
            if venv_path then
                config.settings.python.venvPath = venv_path
                config.settings.python.venv = venv
            end
        end
    elseif server_name == "ocamllsp" then
        opts = require("endoxide.lsp.settings.ocaml")
    elseif server_name == "tsserver" then
        opts = require("endoxide.lsp.settings.tsserver")
    elseif server_name == "omnisharp" then
        opts = require("endoxide.lsp.settings.omnisharp")
    end

    opts = vim.tbl_deep_extend("force", opts, forced_opts)

    if server_name == "rust_analyzer" then
        vim.g.rustaceanvim = vim.tbl_deep_extend("force", vim.g.rustaceanvim or {}, { server = opts })
        return
    end

    require("lspconfig")[server_name].setup(opts)
end

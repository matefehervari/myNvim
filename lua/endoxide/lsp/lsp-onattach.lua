local nnoremap = require("endoxide.keymap").nnoremap
local autocommand = require("endoxide.autocommand")
local augroup = autocommand.augroup
local autocmd = autocommand.autocmd
local tca_ok, tca = pcall(require, "tiny-code-action")
local tb_ok, tb = pcall(require, "telescope.builtin")

if not tb_ok then
    vim.notify("Failed to import 'telescope.builtin' in lsp-setup", 3)
end

local ca_callback = tca_ok and tca.code_action or vim.lsp.buf.code_action
local def_callback = tb_ok and tb.lsp_definitions or vim.lsp.buf.definition
local ref_callback = tb_ok and tb.lsp_references or vim.lsp.buf.references

local M = {}

local function lsp_highlight_document(client)
    -- Set autocommands conditional on server_capabilities
    if not client.resolved_capabilities then
        return
    end

    if client.resolved_capabilities.document_highlight then
        local lsp_highlight_group = augroup("lsp_document_highlight", {})

        autocmd({ "CursorHold", }, {
            group = lsp_highlight_group,
            pattern = "*",
            callback = function()
                vim.lsp.buf.document_highlight()
            end
        })

        autocmd({ "CursorMoved", }, {
            group = lsp_highlight_group,
            pattern = "*",
            callback = function()
                vim.lsp.buf.clear_references()
            end
        })
    end
end

local function lsp_keymaps(bufnr)
    local rounded = { border = "rounded" }
    local buf = { buffer = bufnr }
    nnoremap("gD",         vim.lsp.buf.declaration,    buf)
    nnoremap("gd",         def_callback,               buf)
    nnoremap("K",          vim.lsp.buf.hover,          buf)
    nnoremap("gi",         vim.lsp.buf.implementation, buf)
    -- nnoremap("<C-k>",      vim.lsp.buf.signature_help, buf)
    nnoremap("<leader>rn", vim.lsp.buf.rename,         buf)
    nnoremap("gr",         ref_callback,               buf)
    nnoremap("<leader>ca", ca_callback,                buf)

    nnoremap("[d", function() vim.diagnostic.goto_prev(rounded) end,  buf)
    nnoremap("gl", function() vim.diagnostic.open_float(rounded) end, buf)
    nnoremap("]d", function() vim.diagnostic.goto_next(rounded) end,  buf)
end

M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)

    if client.name == "jdtls" then
        vim.lsp.codelens.refresh()
        if JAVA_DAP_ACTIVE then -- defined in ftplugin
            require("jdtls").setup_dap({ hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs(require("endoxide.lsp.settings.jdtls_dap"))
        end
        client.resolved_capabilities.document_formatting = true
        client.resolved_capabilities.textDocument.completion.completionItem.snippetSupport = false
    elseif client.name == "rust_analyzer" then
        local rt = require("rust-tools")
        nnoremap("K", rt.hover_actions.hover_actions, { buffer = bufnr })
        nnoremap("<leader>ca", rt.code_action_group.code_action_group, { buffer = bufnr })
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M

local keymap = require("endoxide.keymap")
local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap

local autocommand = require("endoxide.autocommand")
local augroup = autocommand.augroup
local autocmd = autocommand.autocmd
local endoxideGroup = autocommand.endoxideGroup
local tca_ok, tca = pcall(require, "tiny-code-action")
local tb_ok, tb = pcall(require, "telescope.builtin")

if not tb_ok then
    vim.notify("Failed to import 'telescope.builtin' in lsp-setup", 3)
end

local ca_callback = tca_ok and tca.code_action or vim.lsp.buf.code_action
local def_callback = tb_ok and tb.lsp_definitions or vim.lsp.buf.definition
local ref_callback = tb_ok and tb.lsp_references or vim.lsp.buf.references

local sev = vim.diagnostic.severity
local ERROR, INFO, HINT = sev.ERROR, sev.INFO, sev.HINT
local rounded = { border = "rounded" }

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

---@param mode '"forward"'|'"reverse"'
local function jump_to_diagnostic(mode)
    local count = vim.diagnostic.count()
    if vim.tbl_isempty(count) then
        return
    end
    for severity = ERROR, HINT do
        local diagnostic
        if mode == "forward" then
            diagnostic = vim.diagnostic.get_next({ severity = severity })
        elseif mode == "reverse" then
            diagnostic = vim.diagnostic.get_prev({ severity = severity })
        end
        if diagnostic then
            vim.diagnostic.jump({ diagnostic = diagnostic, float = { border = "rounded", severity = { INFO, HINT } } })

            local timer = vim.uv.new_timer()
            if timer then
                timer:start(50, 0, vim.schedule_wrap(function() vim.diagnostic.open_float() end))
            end
            break
        end
    end
end

local function lsp_keymaps(bufnr)
    nnoremap("gd", def_callback, { desc = "LSP goto defintion", buffer = bufnr })
    nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP goto declaration", buffer = bufnr })
    nnoremap("gi", vim.lsp.buf.implementation, { desc = "LSP goto implementation", buffer = bufnr })
    nnoremap("gr", ref_callback, { desc = "LSP goto references", buffer = bufnr })
    nnoremap("gt", ca_callback, { desc = "LSP goto type definition", buffer = bufnr })
    nnoremap("K", vim.lsp.buf.hover, { desc = "LSP hover", buffer = bufnr })
    nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP rename", buffer = bufnr })
    nnoremap("<leader>aa", ca_callback, { desc = "LSP code actions", buffer = bufnr })
    nnoremap("<leader>ti", function()
        local enabled = not vim.lsp.inlay_hint.is_enabled({})
        vim.lsp.inlay_hint.enable(enabled)
        vim.notify("Inlay hints: " .. (enabled and " on" or "off"), nil, { title = "Inlay Hints Toggled" })
    end, { desc = "Toggle inlay hints", buffer = bufnr })

    nnoremap("[d", function() jump_to_diagnostic("reverse") end,
        { desc = "Diagnostic goto prev", buffer = bufnr })
    nnoremap("]d", function() jump_to_diagnostic("forward") end,
        { desc = "Diagnostic goto next", buffer = bufnr })
    nnoremap("gl", function() vim.diagnostic.open_float(rounded) end, { desc = "Diagnostic open float", buffer = bufnr })

    nnoremap("gf", function() -- format file
        vim.lsp.buf.format()
    end, { desc = "LSP format buffer" })

    vnoremap("gf", function() -- format file
        vim.lsp.buf.format()
    end, { desc = "LSP format lines" })
end

---Sets LSP configurations base on capabilities on attach
---@param client vim.lsp.Client
---@param bufnr integer
M.on_attach = function(client, bufnr)
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)

    -- Format on save
    if client.capabilities.textDocument.formatting then
        autocmd({ "BufWritePre", }, {
            buffer = 0,
            desc = "Format file before write",
            group = endoxideGroup,
            callback = function()
                vim.lsp.buf.format()
            end
        })
    end


    if client.name == "jdtls" then
        vim.lsp.codelens.refresh()
        if JAVA_DAP_ACTIVE then -- defined in ftplugin
            require("jdtls").setup_dap({ config_overrides = {}, hotcodereplace = "auto" })
            require("jdtls.dap").setup_dap_main_class_configs(require("endoxide.lsp.settings.jdtls_dap"))
        end
    elseif client.name == "rust-analyzer" then
        nnoremap("K", function() vim.cmd.RustLsp({ "hover", "actions" }) end, { desc = "RustLsp Hover", buffer = bufnr })
        nnoremap("<leader>a", function() vim.cmd.RustLsp("codeAction") end,
            { desc = "RustLsp code actions", buffer = bufnr })
        vnoremap("<leader>a", function() vim.cmd.RustLsp("codeAction") end,
            { desc = "RustLsp code actions", buffer = bufnr })
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M

local dap_Status_ok, dap = pcall(require, "dap")
if not dap_Status_ok then
  return
end

local dapui_Status_ok, dapui = pcall(require, "dapui")
if not dapui_Status_ok then
  return
end

local Remap = require("endoxide.keymap")
local nnoremap = Remap.nnoremap

-- nnoremap("<leader>db", function ()
--     dap.toggle_breakpoint()
-- end)
-- nnoremap("<leader>dc", function ()
--     dap.continue()
-- end)
-- nnoremap("<leader>dq", function ()
--     dap.terminate()
-- end)
-- nnoremap("<leader>do", function ()
--     dap.step_over()
-- end)
-- nnoremap("<leader>di", function ()
--     dap.step_into()
-- end)


nnoremap("<leader>b", function()
  dap.toggle_breakpoint()
end)
nnoremap("<F7>", function()
  print(vim.inspect(dap.configurations.java))
  dap.continue()
end)
nnoremap("<leader>dq", function()
  dap.terminate()
  dapui.close()

end)
nnoremap("<F6>", function()
  dap.step_over()
end)
nnoremap("<F5>", function()
  dap.step_into()
end)
nnoremap("<leader>dr", function()
  print(vim.inspect(dap.configurations.java))
  dap.run(dap.configurations.java)
  -- dap.run(vim.tbl_deep_extend(dap.configurations.java), {runtimeArgs = {"-y", "2022", "-d", "10"}})
end)

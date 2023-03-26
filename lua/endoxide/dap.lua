local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
    return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
    return
end

local dap_python_status_ok, dap_python = pcall(require, "dap-python")
if not dap_python_status_ok then
    return
end

local home = os.getenv("HOME")
-- dap_python.setup(home .. "/.virtualenvs/debugpy/bin/python3.10")

-- PYTHON
local python_ver = "python3.10"

dap.adapters.python = {
  type = 'executable';
  command = home .. "/.virtualenvs/debugpy/bin/python3.10";
  args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/' .. python_ver
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/' .. python_ver
      else
        return '/usr/bin/' .. python_ver
      end
    end;
  },
}

-- dap.configurations.java = {{
--               type = "java",
--               request = "launch",
--               name = "Launch Java",
--               runtimeArgs = {"-y", "2022", "-d", "10"},
--           },
--         }
--

-- DAP UI
dapui.setup {
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "l" },
    open = "o",
    remove = "d",
    edit = "c",
    repl = "r",
    toggle = "t",
  },
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "stacks",
        "watches",
      },
      size = 70, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  }
}

vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  print("terminated")
  dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


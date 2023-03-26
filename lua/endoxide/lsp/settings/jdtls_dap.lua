return {
  config_overrides = {console = "internalConsole", -- uses dap_repl
                      -- args = "-y 2022 -d 10",
                      args = function ()
                        local cached_args =  vim.tbl_get(vim.g, "cached_dap_args")
                        local args = ""
                        if cached_args == nil then
                          args = vim.fn.input("DAP args: ")
                        else
                          args = vim.fn.input("DAP args: ", cached_args)
                        end
                        vim.g["cached_dap_args"] = args
                        return args
                      end
                     },
}

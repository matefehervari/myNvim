local M = {}

local output = {
    lua = [[print(%s)]],
    python = [[print(%s)]],
    typescript = [[console.log(%s)]],
    typescriptreact = [[console.log(%s)]],
    c = [[printf(%s);]],
    cpp = [[std::cout << %s std::endl;]],
    cs = [[Console.WriteLine(%s);]],
    java = [[System.out.println(%s);]],
    rust = [[println!("{}", %s)]],
}

local dbg = {
    lua = [[print("%s: " .. vim.inspect(%s))]],
    python = [[print(f"%s: {%s}")]],
    typescript = [[console.log(`"%s: ${%s}`)]],
    typescriptreact = [[console.log(`"%s: ${%s}`)]],
    c = [[printf("%s: %%s", %s);]],
    cpp = [[std::cout << "%s: " << %s << std::endl;]],
    cs = [[Console.WriteLine($"%s {%s}");]],
    java = [[System.out.println("%s: " + %s);]],
    rust = [[println!("%s: {}", %s)]],
}

local mt = {
    -- return parts formed by splitting by format placeholder
    __call = function(self, idx)
        local DELIM = "X"
        local fmt_string = self[idx]

        if not fmt_string then return {} end

        local split_string = fmt_string:gsub("%%s", DELIM)
        local left, right = split_string:match("(.+)" .. DELIM .. "(.+)")

        return { left, right }
    end
}

setmetatable(output, mt)

M.output = output
M.debug = dbg

return M

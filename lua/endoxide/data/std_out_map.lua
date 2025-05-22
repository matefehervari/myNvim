local output = {
    lua = "print(%s)",
    python = "print(%s)",
    typescript = "console.log(%s)",
    typescriptreact = "console.log(%s)",
    c = "printf(%s);",
    cpp = "std::cout << %s std::endl;",
    cs = "Console.WriteLine(%s);",
    java = "System.out.println(%s);",
}

local mt = {
    __call = function (self, idx)
        local DELIM = "X"
        local fmt_string = self[idx]

        if not fmt_string then return {} end

        local split_string = fmt_string:gsub("%%s", DELIM)
        local left, right = split_string:match("(.+)" .. DELIM .. "(.+)")

        return {left, right}
    end
}

setmetatable(output, mt)

return output

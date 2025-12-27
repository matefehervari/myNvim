local util = require("lspconfig.util")

return {
    filetypes = { "kotlin" },
    root_dir = util.root_pattern(
        "settings.gradle",
        "settings.gradle.kts",
        "build.gradle",
        "build.gradle.kts",
        ".git"
    )
}

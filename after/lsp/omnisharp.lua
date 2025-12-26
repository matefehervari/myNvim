return {
    settings = {
        RoslynExtensionsOptions = {
            documentAnalysisTimeoutMs = 30000,
            EnableDecompilationSupport = true,
            EnableImportCompletion = true,
            EnableAnalyzersSupport = true,
            diagnosticWorkersThreadCount = 8,
            inlayHintsOptions = {
                enableForParameters = true,
                forLiteralParameters = true,
                forIndexerParameters = true,
                forObjectCreationParameters = true,
                forOtherParameters = true,
                suppressForParametersThatDifferOnlyBySuffix = false,
                suppressForParametersThatMatchMethodIntent = false,
                suppressForParametersThatMatchArgumentName = false,
                enableForTypes = true,
                forImplicitVariableTypes = false,
                forLambdaParameterTypes = true,
                forImplicitObjectCreation = true
            }
        },
        formattingOptions = {
            enableEditorConfigSupport = true,
            organizeImports = true,
        }
    }
}

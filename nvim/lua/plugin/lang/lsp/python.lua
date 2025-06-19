local M = {}

function M.setup(on_attach, capabilities)
  require('lspconfig').basedpyright.setup({
    on_attach = function(client, bufnr)
      client.server_capabilities.document_formatting = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      basedpyright = {
        analysis = {
          autoSearchPaths = true,
          autoImportCompletions = true,
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = 'basic',
          useLibraryCodeForTypes = true,
          logLevel = "Error",
          diagnosticSeverityOverrides = {
            reportAny = false,
            reportAttributeAccessIssue = false,
            reportArgumentType = false,
            reportAssignmentType = false,
            reportReturnType = false,
            reportMissingTypeArgument = false,
            reportMissingTypeStubs = false,
            reportUnknownArgumentType = false,
            reportUnknownMemberType = false,
            reportUnknownParameterType = false,
            reportUnknownVariableType = false,
            reportUnusedCallResult = false,
          },
        }
      },
      python = {},
    },
  })
  -- require('lspconfig').ruff.setup {
  --   on_attach = function(client, bufnr)
  --     client.server_capabilities.hoverProvider = false
  --     on_attach(client, bufnr)
  --   end,
  --   cmd_env = { RUFF_TRACE = "messages" },
  --   init_options = {
  --     settings = {
  --       logLevel = "error",
  --     },
  --   },
  --   capabilities = capabilities,
  -- }
end

return M

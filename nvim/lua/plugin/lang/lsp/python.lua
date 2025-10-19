local M = {}

function M.setup(on_attach, capabilities)
  vim.lsp.config('basedpyright', {
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
  vim.lsp.enable('basedpyright')
  -- vim.lsp.config('ruff', {
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
  -- })
  -- vim.lsp.enable('ruff')
end

return M

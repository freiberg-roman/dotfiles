local M = {}

function M.setup(on_attach, capabilities)
  require('lspconfig').ts_ls.setup {
    on_attach = function(client, bufnr)
      -- disable tsserver formatting if using external formatter
      client.server_capabilities.documentFormattingProvider = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      completions = { completeFunctionCalls = true },
    },
  }
end

return M

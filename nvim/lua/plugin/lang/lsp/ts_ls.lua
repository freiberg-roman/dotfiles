local M = {}

function M.setup(on_attach, capabilities)
  vim.lsp.config('ts_ls', {
    on_attach = function(client, bufnr)
      -- disable tsserver formatting if using external formatter
      client.server_capabilities.documentFormattingProvider = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      completions = { completeFunctionCalls = true },
    },
  })
  vim.lsp.enable('ts_ls')
end

return M

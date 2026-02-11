local M = {}

function M.setup(capabilities)
  vim.lsp.config('ts_ls', {
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
    end,
    capabilities = capabilities,
    settings = {
      completions = { completeFunctionCalls = true },
    },
  })
  vim.lsp.enable('ts_ls')
end

return M

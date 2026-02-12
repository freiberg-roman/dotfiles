local M = {}

function M.setup(capabilities)
  vim.lsp.config('ty', {
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
    end,
    capabilities = capabilities,
    settings = {
      ty = {
        analysis = {
        },
      },
    },
  })
  vim.lsp.enable('ty')

  vim.lsp.config('ruff', {
    on_attach = function(client, _)
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.definitionProvider = false
    end,
    capabilities = capabilities,
    init_options = {
      settings = {
      }
    }
  })
  vim.lsp.enable('ruff')
end

return M

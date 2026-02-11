local M = {}

function M.setup(on_attach, capabilities)
  vim.lsp.config('ty', {
    on_attach = on_attach,
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
    on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      on_attach(client, bufnr)
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

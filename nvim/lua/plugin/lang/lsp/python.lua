local M = {}

function M.setup(capabilities)
  local util = require('lspconfig.util')

  vim.lsp.config('ty', {
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
    end,
    capabilities = capabilities,
    root_dir = function(fname)
      return util.root_pattern('.git', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt')(fname) or util.path.dirname(fname)
    end,
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

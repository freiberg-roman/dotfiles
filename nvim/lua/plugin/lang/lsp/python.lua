local M = {}

function M.setup(on_attach, capabilities)
  require('lspconfig').pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      pylsp = {
        plugins = {
          pycodestyle = { enabled = false },
          pyflakes   = { enabled = false },
          mccabe     = { enabled = false },
        },
      },
    },
    init_options = { formatting = false },
  }

  require('lspconfig').ruff.setup {
    on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      on_attach(client, bufnr)
    end,
    capabilities = capabilities,
    cmd_env = { RUFF_TRACE = "messages" },
    init_options = {
      settings = {
        logLevel = "error",
      },
    },
  }
end

return M

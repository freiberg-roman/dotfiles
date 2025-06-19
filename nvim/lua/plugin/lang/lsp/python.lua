local M = {}

local path = require("lspconfig").util.path
local function get_python_path()
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end
  return vim.fn.exepath("python") or "python"
end

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
          diagnosticMode = "openFilesOnly",
          useLibraryCodeForTypes = true,
          typeCheckingMode = "all",
          diagnosticSeverityOverrides = {
            reportAny = false,
            reportMissingTypeArgument = false,
            reportMissingTypeStubs = false,
            reportUnknownArgumentType = false,
            reportUnknownMemberType = false,
            reportUnknownParameterType = false,
            reportUnknownVariableType = false,
            reportUnusedCallResult = false,
          },
        },
      },
      python = {},
    },
    before_init = function(_, config)
      local python_path = get_python_path()
      config.settings.python.pythonPath = python_path
      vim.notify(python_path)
    end,
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

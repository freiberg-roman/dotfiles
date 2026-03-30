-- We execute the ty native LSP configuration
vim.lsp.config('ty', {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'uv.lock', '.git' },
})
vim.lsp.enable('ty')

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("TyLspConfig", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or client.name ~= "ty" then
      return
    end

    client.server_capabilities.completionProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.semanticTokensProvider = false
    client.server_capabilities.codeActionProvider = false
    client.server_capabilities.renameProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.workspaceSymbolProvider = false

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf, desc = 'ty: Go to definition' })

    local ns = vim.lsp.diagnostic.get_namespace(client.id)
    vim.diagnostic.config({
      virtual_text = false,
      signs = false,
      underline = false,
      update_in_insert = false,
    }, ns)
  end,
})

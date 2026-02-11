-- Rust-specific keymaps using rustaceanvim's enhanced features.
-- This file is loaded automatically for .rs buffers.

local bufnr = vim.api.nvim_get_current_buf()

local function map(keys, func, desc)
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'Rust: ' .. desc, noremap = true, silent = true })
end

-- Override K with rustaceanvim's enhanced hover (includes actions)
map('K', function() vim.cmd.RustLsp({ 'hover', 'actions' }) end, 'Hover Actions')

-- Grouped code actions (better than vanilla vim.lsp.buf.code_action for Rust)
map('<leader>ca', function() vim.cmd.RustLsp('codeAction') end, 'Code Action')

-- Rust-specific commands
map('<leader>dd', function() vim.cmd.RustLsp('debuggables') end, 'Debuggables')
map('<leader>rr', function() vim.cmd.RustLsp('runnables') end, 'Runnables')
map('<leader>re', function() vim.cmd.RustLsp('explainError') end, 'Explain Error')
map('<leader>rd', function() vim.cmd.RustLsp('renderDiagnostic') end, 'Render Diagnostic')

--
-- files
--
vim.api.nvim_set_keymap("n", "E", "$", { noremap=false })
vim.api.nvim_set_keymap("n", "B", "^", { noremap=false })
vim.api.nvim_set_keymap("n", "<leader>ss", ":noh<CR>", { silent = true, noremap=true })
--
-- splits
--
vim.api.nvim_set_keymap("n", "<C-W>,", ":vertical resize -10<CR>", { noremap=true })
vim.api.nvim_set_keymap("n", "<C-W>.", ":vertical resize +10<CR>", { noremap=true })
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
--
-- Remap for dealing with word wrap
--
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
--
-- Lua configuration
--
vim.keymap.set('n', '<leader><leader>x', '<cmd>source %<CR>')
vim.keymap.set('n', '<leader>x', ':.lua<CR>')
vim.keymap.set('v', '<leader>x', ':lua<CR>')

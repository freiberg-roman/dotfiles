vim.api.nvim_set_keymap("n", "zz", ":ZenMode<enter>", { noremap=false, silent=true })
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
-- Noice
--
vim.api.nvim_set_keymap("n", "<leader>nn", ":Noice dismiss<CR>", { noremap=true, silent=true })

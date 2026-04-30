require("trouble").setup {
  auto_close = true,
}
vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = { severity = vim.diagnostic.severity.ERROR },
  update_in_insert = false,
})

vim.keymap.set("n", "<leader>xx", function() require('telescope.builtin').diagnostics({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Diagnostics (Telescope)" })
vim.keymap.set("n", "<leader>xX", function() require('telescope.builtin').diagnostics({ bufnr = 0, severity = vim.diagnostic.severity.ERROR }) end, { desc = "Buffer Diagnostics (Telescope)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

local dapui = require("dapui")

dapui.setup()

require("dap-python").setup("python")

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
vim.api.nvim_set_keymap("n", "<leader>dc", ":lua require('dap').continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>",
  { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ds", ":lua require('dap').step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>di", ":lua require('dap').step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>do", ":lua require('dap').step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>du", ":lua require('dapui').toggle()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dp", ":lua require('dap').up()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>dn", ":lua require('dap').down()<CR>", { noremap = true, silent = true })

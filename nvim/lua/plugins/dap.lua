-- Minimal nvim-dap configuration for a VSCode-like experience

local dap = require("dap")
local dapui = require("dapui")

-- Setup dap-ui with default settings
dapui.setup()

-- Load launch.json configurations from the .vscode folder, if available.
-- This will merge any found configurations into dap.configurations.
local ok, vscode = pcall(require, "dap.ext.vscode")
if ok then
  vscode.load_launchjs()  -- Reads the .vscode/launch.json file automatically.
end

-- Define a simple sign for breakpoints
vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })

-- Basic key mappings for debugging
vim.api.nvim_set_keymap("n", "<leader>dc", ":lua require('dap').continue()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>db", ":lua require('dap').toggle_breakpoint()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ds", ":lua require('dap').step_over()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>di", ":lua require('dap').step_into()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>do", ":lua require('dap').step_out()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>du", ":lua require('dapui').toggle()<CR>", { noremap = true, silent = true })

----------------------------------------------------------------------
-- 1 General ---------------------------------------------------------
----------------------------------------------------------------------
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
local dap, dapui = require("dap"), require("dapui")
dapui.setup()
require("nvim-dap-virtual-text").setup({
  display_callback = function(v)
    return #v.value > 15 and (" " .. v.value:sub(1, 15) .. "…") or (" " .. v.value)
  end,
})
dap.listeners.before.launch.dapui_config           = function() dapui.open() end
dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end
----------------------------------------------------------------------
-- 2 Python ----------------------------------------------------------
----------------------------------------------------------------------
require("dap-python").setup("python")

------------------------------------------------------------------------
-- 3. Global key‑maps ----------------------------------------------------
------------------------------------------------------------------------
vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue / Run" })
vim.keymap.set("n", "<leader>ds", function() require("dap").step_over() end, { desc = "Step Over" })
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dp", function() require("dap").up() end, { desc = "Stack Up" })
vim.keymap.set("n", "<leader>dn", function() require("dap").down() end, { desc = "Stack Down" })
vim.keymap.set("n", "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, { desc = "Eval" })

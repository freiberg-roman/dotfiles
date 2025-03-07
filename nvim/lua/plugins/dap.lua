vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' })

local dap = require("dap")
local ui = require("dapui")
ui.setup()
require("dap-python").setup("python")

require("nvim-dap-virtual-text").setup({
  display_callback = function(variable)
    if #variable.value > 15 then
      return " " .. string.sub(variable.value, 1, 15) .. "... "
    end

    return " " .. variable.value
  end,
})

vim.keymap.set("n", "<leader>du", ui.toggle)
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<leader>ds", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_out)
vim.keymap.set("n", "<leader>dp", dap.up)
vim.keymap.set("n", "<leader>dn", dap.down)
vim.keymap.set("n", "<leader>de", function()
  require("dapui").eval(nil, { enter = true })
end)
dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end

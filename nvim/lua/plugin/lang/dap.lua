return {
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
    },
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "mfussenegger/nvim-dap-python",
      "williamboman/mason.nvim",
    },
    config = function()
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

      vim.keymap.set("n", "<leader>du", ui.toggle, { desc = 'Toggle DAP UI' })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = 'Continue' })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = 'Step over' })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = 'Step into' })
      vim.keymap.set("n", "<leader>do", dap.step_out, { desc = 'Step out' })
      vim.keymap.set("n", "<leader>dp", dap.up, { desc = 'Up' })
      vim.keymap.set("n", "<leader>dn", dap.down, { desc = 'Down' })
      vim.keymap.set("n", "<leader>de", function()
        require("dapui").eval(nil, { enter = true })
      end, { desc = 'Evaluate expression' })
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
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
  },
}

return {
  {
    "mfussenegger/nvim-dap-python",
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end,          desc = "Debug Method",       ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end,           desc = "Debug Class",        ft = "python" },
      { "<leader>du",  function() require('ui').toogle() end,                       desc = "Toggle DAP UI" },
      { "<leader>db",  function() require('dap').toggle_breakpoint() end,           desc = "Toggle Breakpoint" },
      { "<leader>dc",  function() require('dap').continue() end,                    desc = "Continue" },
      { "<leader>ds",  function() require('dap').step_over() end,                   desc = "Step Over" },
      { "<leader>di",  function() require('dap').step_into() end,                   desc = "Step Into" },
      { "<leader>do",  function() require('dap').step_out() end,                    desc = "Step Out" },
      { "<leader>dp",  function() require('dap').up() end,                          desc = "Up" },
      { "<leader>dn",  function() require('dap').down() end,                        desc = "Down" },
      { "<leader>de",  function() require('dapui').eval(nil, { enter = true }) end, desc = "Evaluate Expression" },
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

      dap.listeners.before.launch.dapui_config = function()
        ui.open()
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

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
    },
    config = function()
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


    end,

    ------------------------------------------------------------------------
    -- 3. Global key‑maps ----------------------------------------------------
    ------------------------------------------------------------------------
    keys = {
      { "<leader>du", function() require("dapui").toggle() end,                    desc = "Toggle DAP UI" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end,           desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end,                    desc = "Continue / Run" },
      { "<leader>ds", function() require("dap").step_over() end,                   desc = "Step Over" },
      { "<leader>di", function() require("dap").step_into() end,                   desc = "Step Into" },
      { "<leader>do", function() require("dap").step_out() end,                    desc = "Step Out" },
      { "<leader>dp", function() require("dap").up() end,                          desc = "Stack Up" },
      { "<leader>dn", function() require("dap").down() end,                        desc = "Stack Down" },
      { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, desc = "Eval" },
    },
  },
}

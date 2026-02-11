return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "mfussenegger/nvim-dap-python",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "Joakker/lua-json5",
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
      require("mason-nvim-dap").setup({
        ensure_installed       = { "python", "js-debug-adapter", "codelldb" },
        automatic_installation = true,
      })
      dap.listeners.before.launch.dapui_config           = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config     = function() dapui.close() end
      ----------------------------------------------------------------------
      -- 2 Python ----------------------------------------------------------
      ----------------------------------------------------------------------
      require("dap-python").setup("python")


      ----------------------------------------------------------------------
      -- 2 JS --------------------------------------------------------------
      ----------------------------------------------------------------------
      local js_debug_path = vim.fn.stdpath("data")
          .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "::1",
        port = "${port}",
        executable = {
          command = "node",
          args    = { js_debug_path, "${port}" },
        },
      }


      dap.adapters["pwa-chrome"] = {
        type = "server",
        host = "::1",
        port = "${port}",
        executable = { command = "node", args = { js_debug_path, "${port}" } },
      }
      local js_langs = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
      for _, language in ipairs(js_langs) do
        dap.configurations[language] = {
          {
            name = "----- launch.json configs (if available) ↑ -----",
            type = "",
            request = "launch",
          },
          {
            name = "Launch Chrome against Next.js",
            type = "pwa-chrome",
            request = "launch",
            url = "http://localhost:3000", -- Assumes Next.js runs on port 3000
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            port = 9222, -- A common debugging port, ensure it's not in use
            userDataDir = false,
          },
        }
      end

      if vim.fn.filereadable(".vscode/launch.json") then
        require("dap.ext.vscode").load_launchjs(nil, {
          ["pwa-node"]   = js_langs,
          ["pwa-chrome"] = js_langs,
        })
      end
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

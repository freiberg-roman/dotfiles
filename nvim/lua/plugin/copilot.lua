return {
  {
    "zbirenbaum/copilot.lua",
    init = function()
      --vim.g.copilot_proxy = "http://your-proxy-host:port"
      vim.g.copilot_proxy_strict_ssl = false
    end,
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = {
        keymap = {
          accept = false,
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    build = "make tiktoken",
    branch = "main",
    cmd = "CopilotChat",
    keys = {
      {
        "<c-s>",
        "<CR>",
        ft = "copilot-chat",
        desc = "Submit Prompt",
        remap = true
      },
      { "<leader>c", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>ca",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>cx",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>cq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>cp",
        function()
          require("CopilotChat").select_prompt()
        end,
        desc = "Prompt Actions (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        model = "gemini-2.5-pro",
        context = { "buffers", "files" },
        window = {
          width = 0.4,
        },
      }
    end,
    config = function(_, opts)
      if vim.uv.os_uname().sysname == "Darwin" then
        vim.env.XDG_RUNTIME_DIR = "/tmp"
      end
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })
      chat.setup(opts)
    end,
  }
}

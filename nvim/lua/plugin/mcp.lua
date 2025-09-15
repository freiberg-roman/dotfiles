return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
  config = function()
    require("mcphub").setup({
      config = vim.fn.expand("~/.config/nvim/mcp/servers.json"),
      auto_approve = true,
      auto_toggle_mcp_servers = true,
      extensions = {
        copilotchat = {
          enabled = true,
          convert_tools_to_functions = true,     -- Convert MCP tools to CopilotChat functions
          convert_resources_to_functions = true, -- Convert MCP resources to CopilotChat functions
          add_mcp_prefix = false,                -- Add "mcp_" prefix to function names
        }
      }
    })
  end
}

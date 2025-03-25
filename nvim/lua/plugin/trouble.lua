return {
    "folke/trouble.nvim",
    lazy = false,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("trouble").setup {}
      local signs = {
          Error = " ",
          Warning = " ",
          Hint = " ",
          Information = " "
      }
      for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
      end
    end,
}

return {
  'nvim-lualine/lualine.nvim',
  event = "VeryLazy",
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = true,
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = { 'filename' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            function() return require("noice").api.status.command.get() end,
            cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            color = { fg = "#ff9e64" },
          },
        },
        lualine_y = {},
        lualine_z = { 'location' },
      }
    }
  end,
}

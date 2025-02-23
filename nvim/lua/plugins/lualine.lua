require('lualine').setup {
  options = {
    icons_enabled = true,
    component_separators = '|',
    section_separators = '',
  },
  sections = {
    lualine_x = {
      {
        require("noice").api.status.command.get,
        cond = require("noice").api.status.command.has,
        color = { fg = "#ff9e64" },
      },
      lualine_y = {},
      lualine_z = {'location'},
    },
    lualine_a = {},
    lualine_b = {},
  }
}


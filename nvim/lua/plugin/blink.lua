return {
  'saghen/blink.cmp',
  version = '*',
  dependencies = { "rafamadriz/friendly-snippets" },
  opts_extend = { "sources.default" },
  config = function()
    require('blink.cmp').setup({
      sources = {
        default = { "path", "snippets", "buffer" },
      }
    })
  end,
}

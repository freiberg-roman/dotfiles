return {
  'saghen/blink.cmp',
  version = '*',
  dependencies = { "giuxtaposition/blink-cmp-copilot", "rafamadriz/friendly-snippets" },
  opts_extend = { "sources.default" },
  config = function()
    require('blink.cmp').setup({
      sources = {
        default = { "copilot", "lsp", "path", "snippets", "buffer" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      }
    })
  end,
}

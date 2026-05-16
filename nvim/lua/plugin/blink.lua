require('blink.cmp').setup({
  sources = {
    default = { "path", "snippets", "buffer" },
    per_filetype = {
      rust = { "lsp", "path", "snippets", "buffer" },
    },
  }
})

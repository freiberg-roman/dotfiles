require('blink.cmp').setup({
  fuzzy = {
    prebuilt_binaries = {
      download = true,
      force_version = 'v1.10.0',
    },
  },
  sources = {
    default = { "path", "snippets", "buffer" },
  }
})

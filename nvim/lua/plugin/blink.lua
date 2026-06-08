require('blink.cmp').setup({
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  sources = {
    -- Only autocomplete from LSPs. No buffer-word guessing.
    default = { "lsp", "snippets", "path" },
  },
})

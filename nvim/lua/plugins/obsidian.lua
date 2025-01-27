require("obsidian").setup({
  workspaces = {
    {
      name = "notes",
      path = "/Users/freiberg/Library/Mobile Documents/iCloud~md~obsidian/Documents/rf2note"
    },
  },
  completion = {
    nvim_cpm = true,
    min_chars = 2,
    new_note_location = "0. Inbox",
  },
  mappings = {
    ["<leader>of"] = {
      action = function()
        return require("obsidian").util.gf_passthrough()
      end,
      opts = { noremap = false, expr = true, buffer = true },
    },
  },
  templates = {
    folder = "Templates",
    date_format = "%Y-%m-%d",
    time_format = "%H:%M",
  },
})


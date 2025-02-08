local obsidian_dir = os.getenv("OBSIDIAN_DIR")
if not obsidian_dir then
  print("OBSIDIAN_DIR is not set. Skipping Obsidian plugin setup.")
  return
end

require("obsidian").setup({
  workspaces = {
    {
      name = "notes",
      path = obsidian_dir,
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


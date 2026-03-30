vim.keymap.set('n', '<leader>sf', function() require('telescope.builtin').find_files() end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', function() require('telescope.builtin').help_tags() end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', function() require('telescope.builtin').grep_string() end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', function() require('telescope.builtin').live_grep() end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', function() require('telescope.builtin').diagnostics() end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sb', function() require('telescope.builtin').buffers() end, { desc = 'List open buffers' })
vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<CR>', { desc = 'Search TODOs' })
vim.keymap.set('n', '<leader><tab>', function() require('telescope.builtin').commands() end, { desc = 'List commands' })

require('telescope').setup {
  defaults = {
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = { width = 0.95, height = 0.95, preview_width = 0.65 },
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
        ['<C-j>'] = require('telescope.actions').move_selection_next,
        ['<C-k>'] = require('telescope.actions').move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = { theme = "dropdown" },
  },
}

if vim.fn.executable('make') == 1 then
  pcall(require('telescope').load_extension, 'fzf')
end

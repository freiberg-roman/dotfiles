return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            preview_width = 0.65,
            horizontal = {
              size = {
                width = "95%",
                height = "95%",
              },
            },
          },
          pickers = {
            find_files = {
              theme = "dropdown",
            }
          },
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
              ["<C-j>"] = require('telescope.actions').move_selection_next,
              ["<C-k>"] = require('telescope.actions').move_selection_previous,
              ["<C-d>"] = require('telescope.actions').move_selection_previous,
            },
          },
        },
      }
    end,
    keys = {
      { '<leader>sf',    require('telescope.builtin').find_files,                        { desc = '[S]earch [F]iles' } },
      { '<leader>sh',    require('telescope.builtin').help_tags,                         { desc = '[S]earch [H]elp' } },
      { '<leader>sw',    require('telescope.builtin').grep_string,                       { desc = '[S]earch current [W]ord' } },
      { '<leader>sg',    require('telescope.builtin').live_grep,                         { desc = '[S]earch by [G]rep' } },
      { '<leader>sd',    require('telescope.builtin').diagnostics,                       { desc = '[S]earch [D]iagnostics' } },
      { '<leader>sb',    require('telescope.builtin').buffers,                           { desc = '[ ] Find existing buffers' } },
      { '<leader>sn',    '<cmd>lua require("telescope").extensions.notify.notify()<CR>', { desc = '' } },
      { '<leader>st',    ':TodoTelescope<CR>',                                           { desc = '' } },
      { '<leader><tab>', '<cmd>lua require("telescope.builtin").commands()<CR>',         { desc = '' } },
    },
  },
  { 'nvim-telescope/telescope-symbols.nvim' },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable 'make' == 1,
    config = function()
      pcall(require('telescope').load_extension, 'fzf')
    end,
  },
}

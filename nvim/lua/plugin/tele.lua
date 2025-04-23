return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = 'Telescope',
    keys = {
      { '<leader>sf',    function() require('telescope.builtin').find_files() end,  desc = '[S]earch [F]iles' },
      { '<leader>sh',    function() require('telescope.builtin').help_tags() end,   desc = '[S]earch [H]elp' },
      { '<leader>sw',    function() require('telescope.builtin').grep_string() end, desc = '[S]earch current [W]ord' },
      { '<leader>sg',    function() require('telescope.builtin').live_grep() end,   desc = '[S]earch by [G]rep' },
      { '<leader>sd',    function() require('telescope.builtin').diagnostics() end, desc = '[S]earch [D]iagnostics' },
      { '<leader>sb',    function() require('telescope.builtin').buffers() end,     desc = 'List open buffers' },
      { '<leader>st',    '<cmd>TodoTelescope<CR>',                                  desc = 'Search TODOs' },
      { '<leader><tab>', function() require('telescope.builtin').commands() end,    desc = 'List commands' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { width = 0.95, height = 0.95 },
            preview_width = 0.65,
          },
          pickers = {
            find_files = { theme = "dropdown" },
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
      }
    end,
  },

  -- optional extensions:
  { 'nvim-telescope/telescope-symbols.nvim' },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build  = 'make',
    cond   = vim.fn.executable('make') == 1,
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
}

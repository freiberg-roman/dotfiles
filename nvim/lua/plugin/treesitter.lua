return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = function()
    pcall(require('nvim-treesitter.install').update { with_sync = true })
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'go', 'lua', 'python', 'rust', 'typescript', 'regex',
        'bash', 'markdown', 'markdown_inline', 'kdl', 'sql', 'terraform',
        'html', 'css', 'javascript', 'yaml', 'json', 'toml',
        'ninja', 'rst', 'ron'
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<c-space>',
          node_incremental = '<c-space>',
          scope_incremental = '<c-s>',
          node_decremental = '<c-backspace>',
        },
      },
      textobjects = {
        select = {
          enable = false,
          lookahead = true,
          keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['ii'] = '@conditional.inner',
            ['ai'] = '@conditional.outer',
            ['at'] = '@comment.outer',
          },
        },
        move = {
          enable = false,
          set_jumps = true,
        },
        swap = {
          enable = true,
          swap_next = {
            ['<leader>a'] = '@parameter.inner',
          },
          swap_previous = {
            ['<leader>A'] = '@parameter.inner',
          },
        },
      },
    }
  end,
}

-- Install parsers
require('nvim-treesitter').install({
  'go', 'lua', 'python', 'rust', 'regex',
  'bash', 'markdown', 'markdown_inline', 'kdl', 'sql', 'terraform',
  'html', 'css', 'yaml', 'json', 'toml',
  'ninja', 'rst', 'ron'
})

-- Enable highlighting globally
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

-- Enable folding globally
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldmethod = 'expr'

-- Enable indenting globally
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Handle nvim-treesitter-textobjects setup
require("nvim-treesitter-textobjects").setup({
  select = {
    enable = false,
    lookahead = true,
  },
  move = {
    enable = false,
    set_jumps = true,
  },
})

-- Manual textobject keymaps (select)
vim.keymap.set({ "x", "o" }, "aa", function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects") end, { desc = "Select parameter outer" })
vim.keymap.set({ "x", "o" }, "ia", function() require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects") end, { desc = "Select parameter inner" })
vim.keymap.set({ "x", "o" }, "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end, { desc = "Select class outer" })
vim.keymap.set({ "x", "o" }, "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end, { desc = "Select class inner" })
vim.keymap.set({ "x", "o" }, "ii", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.inner", "textobjects") end, { desc = "Select conditional inner" })
vim.keymap.set({ "x", "o" }, "ai", function() require("nvim-treesitter-textobjects.select").select_textobject("@conditional.outer", "textobjects") end, { desc = "Select conditional outer" })
vim.keymap.set({ "x", "o" }, "at", function() require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects") end, { desc = "Select comment outer" })

-- Manual textobject keymaps (swap)
vim.keymap.set("n", "<leader>a", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner") end, { desc = "Swap next parameter" })
vim.keymap.set("n", "<leader>A", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner") end, { desc = "Swap previous parameter" })

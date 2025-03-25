local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.o.termguicolors = true

require('lazy').setup({
  { import = "plugin" },
  { import = "plugin.lang" },
  {
    'MeanderingProgrammer/markdown.nvim',
    main = "render-markdown",
    opts = {},
    name = 'render-markdown',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  },
  "preservim/vim-pencil",
  'tpope/vim-obsession',

  {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  },
  'ray-x/guihua.lua',
  {
    "catppuccin/nvim",
    as = "catppuccin"
  },
  -- Git related plugins
  'tpope/vim-fugitive',
  { "lukas-reineke/indent-blankline.nvim", main = "ibl",     opts = {} },
  'tpope/vim-sleuth',          -- Detect tabstop and shiftwidth automatically
  -- Fuzzy Finder (files, lsp, etc)
  {
    "folke/twilight.nvim",
    ft = "markdown",
    opts = {
    }
  },
})

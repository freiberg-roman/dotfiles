local gh = function(x) return "https://github.com/" .. x end

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path }):wait()
    end
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      vim.defer_fn(function() vim.cmd('TSUpdateSync') end, 1000)
    end
  end
})

vim.pack.add({
  gh("MeanderingProgrammer/render-markdown.nvim"),
  gh("nvim-treesitter/nvim-treesitter"),
  gh("nvim-treesitter/nvim-treesitter-textobjects"),
  gh("nvim-tree/nvim-web-devicons"),
  gh("tpope/vim-obsession"),
  gh("folke/todo-comments.nvim"),
  gh("nvim-lua/plenary.nvim"),
  gh("catppuccin/nvim"),
  gh("lukas-reineke/indent-blankline.nvim"),
  gh("tpope/vim-sleuth"),
  gh("saghen/blink.cmp"),
  gh("rafamadriz/friendly-snippets"),
  gh("lewis6991/gitsigns.nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("echasnovski/mini.nvim"),
  gh("folke/noice.nvim"),
  gh("MunifTanjim/nui.nvim"),
  gh("rcarriga/nvim-notify"),
  gh("stevearc/oil.nvim"),
  gh("echasnovski/mini.icons"),
  gh("nvim-telescope/telescope.nvim"),
  gh("nvim-telescope/telescope-symbols.nvim"),
  gh("nvim-telescope/telescope-fzf-native.nvim"),
  gh("folke/trouble.nvim"),
  gh("mfussenegger/nvim-dap"),
  gh("rcarriga/nvim-dap-ui"),
  gh("nvim-neotest/nvim-nio"),
  gh("theHamsta/nvim-dap-virtual-text"),
  gh("mfussenegger/nvim-dap-python"),
  gh("mrcjkb/rustaceanvim"),
}, { confirm = false })


require("render-markdown").setup {}
require("todo-comments").setup {}
require("ibl").setup {}

require('plugin.blink')
require('plugin.gitsigns')
require('plugin.lualine')
require('plugin.mini')
require('plugin.noice')
require('plugin.oil')
require('plugin.tele')
require('plugin.treesitter')
require('plugin.trouble')
require('plugin.lang.dap')
require('plugin.lang.rust')
require('plugin.lang.ty')

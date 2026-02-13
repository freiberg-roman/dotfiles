return {
  { 'onsails/lspkind.nvim' },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'saghen/blink.cmp',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },

    config = function()
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

      -- Shared keymaps for ALL LSP clients (including rust-analyzer)
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(ev)
          local bufnr = ev.buf
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
          end

          nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          nmap('<leader>D', vim.lsp.buf.type_definition, '[G]oto [T]ype [D]efinition')
          nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format({
              async = false,
              filter = function(client) return client.name == 'ruff' end,
            })
          end, { desc = 'Format current buffer with LSP (ruff)' })
        end,
      })

      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('LspFormatOnSave', { clear = true }),
        callback = function(args)
          if #vim.lsp.get_clients({ bufnr = args.buf }) == 0 then return end
          vim.lsp.buf.format({
            bufnr = args.buf,
            timeout_ms = 1000,
            filter = function(client) return client.name == 'ruff' end,
          })
        end,
      })

      -- Setup mason so it can manage external tooling
      require('mason').setup()

      -- Broadcast blink.cmp capabilities to ALL LSP servers
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      vim.lsp.config('*', {
        capabilities = capabilities,
      })

      -- Enable the following language servers
      local servers = { 'dockerls', 'jsonls', 'yamlls' }
      for _, lsp in ipairs(servers) do
        vim.lsp.enable(lsp)
      end

      -- Per-language configurations
      require('plugin.lang.lsp.python').setup(capabilities)
      require('plugin.lang.lsp.lua_ls').setup(capabilities)
      require('plugin.lang.lsp.ts_ls').setup(capabilities)
    end,
  },
}

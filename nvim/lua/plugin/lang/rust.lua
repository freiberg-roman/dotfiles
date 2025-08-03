return {
  {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'jay-babu/mason-nvim-dap.nvim',
    },
    version = '*',
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          -- Helper for setting normal-mode keymaps
          local nmap = function(keys, func, desc)
            if desc then
              desc = 'LSP: ' .. desc
            end
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
          end

          -- Standard LSP keymaps
          nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
          nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
          nmap('<leader>D', vim.lsp.buf.type_definition, '[G]oto [T]ype [D]efinition')
          nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
          nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action,
            { buffer = bufnr, desc = 'LSP: [C]ode [A]ction', noremap = true, silent = true })

          -- Rust-specific keymap
          vim.keymap.set("n", "<leader>dd", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr, noremap = true, silent = true })

          -- Optional: Command for formatting
          vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
            vim.lsp.buf.format({ async = false })
          end, { desc = 'Format current buffer with LSP' })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            checkOnSave = true,
            diagnostics = { enable = true },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            files = {
              excludeDirs = {
                ".direnv",
                ".git",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- This section for DAP is unchanged and correct
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        automatic_installation = true,
      })

      local install_root = vim.fn.stdpath("data") .. "/mason"
      local pkg_path = install_root .. "/packages/codelldb"
      local adapter_path = pkg_path .. "/extension/adapter/codelldb"
      local uname = vim.loop.os_uname().sysname
      local lib_name = (uname == "Linux") and "liblldb.so" or "liblldb.dylib"
      local lib_path = pkg_path .. "/extension/lldb/lib/" .. lib_name

      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(adapter_path, lib_path),
      }

      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}

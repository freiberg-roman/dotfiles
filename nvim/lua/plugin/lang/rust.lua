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
          vim.keymap.set("n", "<leader>dd", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
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
      -- Ensure codelldb is installed via mason-nvim-dap
      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb" },
        automatic_installation = true,
      })

      -- Compute Mason's install root and the codelldb package path
      local install_root = vim.fn.stdpath("data") .. "/mason"
      local pkg_path = install_root .. "/packages/codelldb"
      local adapter_path = pkg_path .. "/extension/adapter/codelldb"

      -- Determine platform-specific LLDB library
      local uname = vim.loop.os_uname().sysname
      local lib_name = (uname == "Linux") and "liblldb.so" or "liblldb.dylib"
      local lib_path = pkg_path .. "/extension/lldb/lib/" .. lib_name

      -- Configure DAP adapter for Rust
      opts.dap = {
        adapter = require("rustaceanvim.config").get_codelldb_adapter(adapter_path, lib_path),
      }

      -- Merge into global rustaceanvim config
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
    end,
  },
}

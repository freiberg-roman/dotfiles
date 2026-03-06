return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = function()
        local exepath = vim.fn.exepath("codelldb")
        local codelldb_path = exepath
        local liblldb_path = ""

        if exepath ~= "" then
          local base_path = exepath:match("(.*)/bin/codelldb$")
          if base_path then
            liblldb_path = base_path .. "/extension/lldb/lib/liblldb.dylib"
          else
            codelldb_path = "codelldb"
            liblldb_path = "liblldb.dylib"
          end
        end

        local cfg = require('rustaceanvim.config')
        return {
          dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
          },
        }
      end
    end
  },
}

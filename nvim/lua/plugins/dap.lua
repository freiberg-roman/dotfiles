require('dapui').setup()
require('dap-go').setup()
require('nvim-dap-virtual-text').setup()
local dap = require("dap")

vim.fn.sign_define('DapBreakpoint', { text='B', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })

-- Debugger
vim.api.nvim_set_keymap("n", "<leader>dt", ":DapUiToggle<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "<leader>ht", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", {noremap=true})


------------------------------------------------------------------------------
-- HELPER: Resolve Python executable path
------------------------------------------------------------------------------
local function get_python_path()
  -- If inside a dev container, or if `python` is the correct interpreter there,
  -- you may simply return "python" or some container-specific path.
  -- (e.g., "/usr/local/bin/python", or "/workspace/.venv/bin/python" etc.)
  --
  -- local is_devcontainer = os.getenv("DEVCONTAINER") or os.getenv("CODESPACES")
  -- if is_devcontainer then
  --   return "python"
  -- end

  -- 1) Conda environment?
  local conda_prefix = os.getenv("CONDA_PREFIX")
  if conda_prefix then
    local conda_python = conda_prefix .. "/bin/python"
    if vim.fn.executable(conda_python) == 1 then
      return conda_python
    end
  end

  -- 2) Virtual environment in the project folder? (common names: venv, .venv)
  if vim.fn.executable("./venv/bin/python") == 1 then
    return "./venv/bin/python"
  elseif vim.fn.executable("./.venv/bin/python") == 1 then
    return "./.venv/bin/python"
  end

  -- 3) macOS default via homebrew, if available
  if vim.fn.has("macunix") == 1 then
    if vim.fn.executable("/usr/local/bin/python3") == 1 then
      return "/usr/local/bin/python3"
    elseif vim.fn.executable("/opt/homebrew/bin/python3") == 1 then
      return "/opt/homebrew/bin/python3"
    end
  end

  -- 4) Fallback to system Python
  if vim.fn.executable("/usr/bin/python3") == 1 then
    return "/usr/bin/python3"
  end

  -- 5) If nothing else, hope "python" is on the PATH:
  return "python"
end

------------------------------------------------------------------------------
-- HELPER: Load project-specific DAP config if available
------------------------------------------------------------------------------
local function load_project_specific_dap()
  local dap_config_path = vim.fn.getcwd() .. "/.vim/dap.lua"
  if vim.fn.filereadable(dap_config_path) == 1 then
    -- If `.vim/dap.lua` returns a table of { dap = { adapters = ..., configurations = ...} }
    local project_dap = dofile(dap_config_path)
    if project_dap and project_dap.dap then
      if project_dap.dap.adapters then
        for adapter_name, adapter_config in pairs(project_dap.dap.adapters) do
          dap.adapters[adapter_name] = adapter_config
        end
      end
      if project_dap.dap.configurations then
        for language, configs in pairs(project_dap.dap.configurations) do
          dap.configurations[language] = configs
        end
      end
      return
    end
  end

  -- Otherwise, we set our default config here:
  dap.adapters.python = {
    type = "executable",
    command = get_python_path(),         -- Important for macOS + dev containers
    args = { "-m", "debugpy.adapter" },
  }
  dap.configurations.python = {
    {
      type = "python",
      request = "launch",
      name = "Launch file",
      -- This is your main script (by default the current buffer)
      -- Or set to something else if you'd like a fixed script.
      program = "${file}",
      -- Where to launch the process; typically the project root:
      cwd = "${workspaceFolder}",

      -- Supply your python path via function
      pythonPath = function()
        return get_python_path()
      end,

      -- For arguments and environment variables:
      args = function()
        -- input prompt in the command line
        local args_str = vim.fn.input("Debug args (space separated): ")
        return vim.split(args_str, " ", { trimempty = true })
      end,
      env = function()
        -- Very simplistic "KEY=VALUE,KEY=VALUE" parser:
        local input_str = vim.fn.input("Env (KEY=VALUE, comma separated): ")
        local env_vars = {}
        for _, pair in ipairs(vim.split(input_str, ",")) do
          local kv = vim.split(pair, "=")
          if #kv == 2 then
            env_vars[kv[1]] = kv[2]
          end
        end
        return env_vars
      end,

      -- Others:
      console = "integratedTerminal",    -- or "externalTerminal"
      justMyCode = false,               -- step into external libraries if needed
    },
  }
end

------------------------------------------------------------------------------
-- MAIN: Load either project-specific or fallback
------------------------------------------------------------------------------
load_project_specific_dap()

------------------------------------------------------------------------------
-- OPTIONAL: Automatically load .vscode/launch.json if it exists
------------------------------------------------------------------------------
-- This parses launch.json and populates DAP configurations automatically.
-- Make sure you've installed the 'dap.ext.vscode' extension:
--   :help dap.ext.vscode.load_launchjs()
--
-- The second argument is a table that maps filetype -> adapter name.
-- For Python: { "python" }.
--
local has_vscode, vscode = pcall(require, "dap.ext.vscode")
if has_vscode then
  -- If a .vscode/launch.json exists in the current workspace,
  -- this function merges or appends the found configurations:
  vscode.load_launchjs(nil, { python = { "python" } })
end


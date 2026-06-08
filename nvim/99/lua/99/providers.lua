--- @class _99.Providers.Observer
--- @field on_stdout fun(line: string): nil
--- @field on_stderr fun(line: string): nil
--- @field on_complete fun(status: _99.Prompt.EndingState, res: string): nil
--- @field on_start fun(): nil

--- @param fn fun(...: any): nil
--- @return fun(...: any): nil
local function once(fn)
  local called = false
  return function(...)
    if called then
      return
    end
    called = true
    fn(...)
  end
end

--- @class _99.Providers.BaseProvider
--- @field _build_command fun(self: _99.Providers.BaseProvider, query: string, context: _99.Prompt): string[]
--- @field _get_provider_name fun(self: _99.Providers.BaseProvider): string
--- @field _get_default_model fun(): string
local BaseProvider = {}

--- @param callback fun(models: string[]|nil, err: string|nil): nil
function BaseProvider.fetch_models(callback)
  callback(nil, "This provider does not support listing models")
end

--- @param context _99.Prompt
function BaseProvider:_retrieve_response(context)
  local logger = context.logger:set_area(self:_get_provider_name())
  local tmp = context.tmp_file
  local success, result = pcall(function()
    return vim.fn.readfile(tmp)
  end)

  if not success then
    logger:error(
      "retrieve_results: failed to read file",
      "tmp_name",
      tmp,
      "error",
      result
    )
    return false, ""
  end

  local str = table.concat(result, "\n")
  logger:debug("retrieve_results", "results", str)

  return true, str
end

--- @param query string
--- @param context _99.Prompt
--- @param observer _99.Providers.Observer
function BaseProvider:make_request(query, context, observer)
  observer.on_start()

  local logger = context.logger:set_area(self:_get_provider_name())
  logger:debug("make_request", "tmp_file", context.tmp_file)

  local once_complete = once(
    --- @param status "success" | "failed" | "cancelled"
    ---@param text string
    function(status, text)
      observer.on_complete(status, text)
    end
  )

  local command = self:_build_command(query, context)
  local extra_args = context._99 and context._99.provider_extra_args or {}
  if #extra_args > 0 then
    vim.list_extend(command, extra_args)
  end
  logger:debug("make_request", "command", command)

  local env = self._get_env and self:_get_env(context) or nil
  local proc = vim.system(
    command,
    {
      text = true,
      env = env,
      stdout = vim.schedule_wrap(function(err, data)
        logger:debug("stdout", "data", data)
        if context:is_cancelled() then
          once_complete("cancelled", "")
          return
        end
        if err and err ~= "" then
          logger:debug("stdout#error", "err", err)
        end
        if not err and data then
          observer.on_stdout(data)
        end
      end),
      stderr = vim.schedule_wrap(function(err, data)
        logger:debug("stderr", "data", data)
        if context:is_cancelled() then
          once_complete("cancelled", "")
          return
        end
        if err and err ~= "" then
          logger:debug("stderr#error", "err", err)
        end
        if not err then
          observer.on_stderr(data)
        end
      end),
    },
    vim.schedule_wrap(function(obj)
      if context:is_cancelled() then
        once_complete("cancelled", "")
        logger:debug("on_complete: request has been cancelled")
        return
      end
      if obj.code ~= 0 then
        local str =
          string.format("process exit code: %d\n%s", obj.code, vim.inspect(obj))
        once_complete("failed", str)
        logger:fatal(
          self:_get_provider_name() .. " make_query failed",
          "obj from results",
          obj
        )
      else
        vim.schedule(function()
          local ok, res = self:_retrieve_response(context)
          if ok then
            once_complete("success", res)
          else
            once_complete(
              "failed",
              "unable to retrieve response from temp file"
            )
          end
        end)
      end
    end)
  )

  context:_set_process(proc)
end

--- @class PiProvider : _99.Providers.BaseProvider
local PiProvider = setmetatable({}, { __index = BaseProvider })

local REPLACE_EXTENSION = vim.fn.expand("~/.pi/agent/extensions/replace-99.ts")

--- @param query string
--- @param context _99.Prompt
--- @return string[]
function PiProvider._build_command(_, query, context)
  return {
    "pi",
    "--model", context.model,
    "--print",
    "--no-extensions",
    "-e", REPLACE_EXTENSION,
    "--tools", "read,ls,find,grep,replace",
    query,
  }
end

--- @param context _99.Prompt
--- @return table<string, string>
function PiProvider._get_env(_, context)
  return { PI_REPLACE_OUTPUT = context.tmp_file }
end

--- @return string
function PiProvider._get_provider_name()
  return "PiProvider"
end

--- @return string
function PiProvider._get_default_model()
  return "ollama/gemma4:12b-mlx"
end

--- @param callback fun(models: string[]|nil, err: string|nil): nil
function PiProvider.fetch_models(callback)
  vim.system({ "pi", "--list-models" }, { text = true }, function(obj)
    if obj.code ~= 0 then
      callback(nil, "Failed to fetch models from pi: " .. (obj.stderr or ""))
      return
    end

    local models = {}
    -- skip header
    local lines = vim.split(obj.stdout, "\n", { trimempty = true })
    for i = 2, #lines do
      local line = lines[i]
      local parts = vim.split(line, "%s+", { trimempty = true })
      if #parts >= 2 then
        local provider = parts[1]
        local model = parts[2]
        table.insert(models, provider .. "/" .. model)
      end
    end
    callback(models, nil)
  end)
end

return {
  BaseProvider = BaseProvider,
  PiProvider = PiProvider,
}

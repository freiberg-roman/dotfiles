--- @class _99.Prompts.SpecificOperations
--- @field visual_selection fun(range: _99.Range): string
--- @field prompt fun(prompt: string, action: string, name?: string): string
--- @field role fun(): string
--- @field read_tmp fun(): string
local prompts = {
  role = function()
    return [[ You are a software engineering assistant mean to create robust and conanical code ]]
  end,
  output_file = function()
    return [[
NEVER alter any file other than TEMP_FILE.
ONLY provide requested changes by writing the change to TEMP_FILE
]]
  end,
  --- @param prompt string
  --- @param action string
  --- @param name? string defaults to DIRECTIONS
  --- @return string
  prompt = function(prompt, action, name)
    name = name or "Prompt"
    return string.format(
      [[
<Context>
%s
</Context>
<%s>
%s
</%s>
]],
      action,
      name,
      prompt,
      name
    )
  end,
  visual_selection = function(range)
    local file_path = vim.api.nvim_buf_get_name(range.buffer)
    return string.format(
      [[
Task: OVERRIDE the provided selection in the TEMP_FILE using SINGLE write call.
Context: Use your read tool on ORIGINAL_FILE to gather any necessary information and your read + bash tools to gather further required information.
OVERRIDE means: The TEMP_FILE content replaces ONLY the selection! Other parts of the file stay as is.
File: %s
Range: %s

<TEMP_FILE WILL OVERRIDE THIS>
%s
</TEMP_FILE WILL OVERRIDE THIS>
]],
      file_path,
      string.format("Lines %d-%d", range.start.row, range.end_.row),
      range:to_text()
    )
  end,
  read_tmp = function()
    return [[
Never attempt to read TEMP_FILE. It is purely for output.
After write to TEMP_FILE once you should be done -> end session.
]]
  end,
}

--- @class _99.Prompts
local prompt_settings = {
  prompts = prompts,

  --- @param tmp_file string
  --- @return string
  tmp_file_location = function(tmp_file)
    return string.format("<TEMP_FILE>%s</TEMP_FILE>", tmp_file)
  end,

  --- @return string
  only_tmp_file_change = function()
    return string.format(
      "<MustObey>\n%s\n%s\n</MustObey>",
      prompts.output_file(),
      prompts.read_tmp()
    )
  end,
}

return prompt_settings

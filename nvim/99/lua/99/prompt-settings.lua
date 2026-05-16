--- @class _99.Prompts.SpecificOperations
--- @field visual_selection fun(range: _99.Range): string
--- @field prompt fun(prompt: string, action: string, name?: string): string
--- @field replace_instruction fun(): string
local prompts = {
  replace_instruction = function()
    return [[
Task: replace the provided selection using a single replace tool call.
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

  --- @param range _99.Range
  --- @return string
  visual_selection = function(range)
    local file_path = vim.api.nvim_buf_get_name(range.buffer)
    local total_lines = vim.api.nvim_buf_line_count(range.buffer)
    local s_row, _ = range.start:to_vim()
    local e_row, _ = range.end_:to_vim()

    local start_ctx = math.max(0, s_row)
    local end_ctx = math.min(total_lines, e_row + 1)

    local lines_above = vim.api.nvim_buf_get_lines(range.buffer, start_ctx, s_row, false)
    local lines_below = vim.api.nvim_buf_get_lines(range.buffer, e_row + 1, end_ctx, false)

    local diff_lines = {}
    for _, line in ipairs(lines_above) do
      table.insert(diff_lines, "  " .. line)
    end

    local selected_text = range:to_text()
    if selected_text ~= "" then
      local selected_lines = vim.split(selected_text, "\n")
      for _, line in ipairs(selected_lines) do
        table.insert(diff_lines, "- " .. line)
      end
    end

    for _, line in ipairs(lines_below) do
      table.insert(diff_lines, "  " .. line)
    end

    local diff_block = "@@\n" .. table.concat(diff_lines, "\n") .. "\n@@"

    return string.format(
      [[
File: %s
Selected lines in file: %s
Selected lines with leading (-):
%s
]],
      file_path,
      string.format("Lines %d-%d", range.start.row, range.end_.row),
      diff_block
    )
  end,
}

--- @class _99.Prompts
local prompt_settings = {
  prompts = prompts,

  --- @return string
  replace_instruction = function()
    return prompts.replace_instruction()
  end,
}

return prompt_settings

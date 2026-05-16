local Mark = require("99.ops.marks")
local geo = require("99.geo")
local make_prompt = require("99.ops.make-prompt")
local CleanUp = require("99.ops.clean-up")

local make_clean_up = CleanUp.make_clean_up
local make_observer = CleanUp.make_observer

local Range = geo.Range
local Point = geo.Point

--- @param context _99.Prompt
--- @param opts? _99.ops.Opts
local function over_range(context, opts)
  opts = opts or {}
  local logger = context.logger:set_area("visual")

  local data = context:visual_data()
  local range = data.range
  local top_mark = Mark.mark_point(range.buffer, range.start)
  local bottom_mark = Mark.mark_point(range.buffer, range.end_)
  context.marks.top_mark = top_mark
  context.marks.bottom_mark = bottom_mark

  logger:debug(
    "visual request start",
    "start",
    Point.from_mark(top_mark),
    "end",
    Point.from_mark(bottom_mark)
  )

  local ns = vim.api.nvim_create_namespace("99.selection")
  local s_row, _ = range.start:to_vim()
  local e_row, _ = range.end_:to_vim()

  -- Static virtual text indicators (no animation)
  local top_extmark = vim.api.nvim_buf_set_extmark(range.buffer, ns, s_row, 0, {
    virt_text = { { " ▎ replacing…", "DiagnosticInfo" } },
    virt_text_pos = "right_align",
  })
  local bottom_extmark = vim.api.nvim_buf_set_extmark(range.buffer, ns, e_row, 0, {
    virt_text = { { " ▎", "DiagnosticInfo" } },
    virt_text_pos = "right_align",
  })

  -- Highlight the selected range with a subtle background
  for row = s_row, e_row do
    vim.api.nvim_buf_set_extmark(range.buffer, ns, row, 0, {
      line_hl_group = "Visual",
      priority = 50,
    })
  end

  local clean_up = make_clean_up(function()
    vim.api.nvim_buf_del_extmark(range.buffer, ns, top_extmark)
    vim.api.nvim_buf_del_extmark(range.buffer, ns, bottom_extmark)
    vim.api.nvim_buf_clear_namespace(range.buffer, ns, s_row, e_row + 1)
  end)

  local system_cmd = context._99.prompts.prompts.visual_selection(range)
  local prompt, refs = make_prompt(context, system_cmd, opts)

  context:add_prompt_content(prompt)
  context:add_references(refs)
  context:add_clean_up(clean_up)

  context:start_request(make_observer(context, {
    on_complete = function(status, response)
      if status == "cancelled" then
        logger:debug("request cancelled for visual selection, removing marks")
      elseif status == "failed" then
        logger:error(
          "request failed for visual_selection",
          "error response",
          response or "no response provided"
        )
      elseif status == "success" then
        local valid = top_mark:is_valid() and bottom_mark:is_valid()
        if not valid then
          logger:fatal(
            -- luacheck: ignore 631
            "the original visual_selection has been destroyed.  You cannot delete the original visual selection during a request"
          )
          return
        end

        if vim.trim(response) == "" then
          print("response was empty, visual replacement aborted")
          logger:debug("response was empty, visual replacement aborted")
          return
        end

        local new_range = Range.from_marks(top_mark, bottom_mark)
        local lines = vim.split(response, "\n")

        new_range:replace_text(lines)
        context._99:sync()
      end
    end,
    on_stdout = function(_) end,
  }))
end

return over_range

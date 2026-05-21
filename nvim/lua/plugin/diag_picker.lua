-- Custom three-panel Telescope diagnostics picker
-- Left:         compact list (file:line [severity])
-- Top-right:    file preview at error location
-- Bottom-right: full diagnostic message

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local Path = require("plenary.path")

local severity_label = {
  [vim.diagnostic.severity.ERROR] = "E",
  [vim.diagnostic.severity.WARN]  = "W",
  [vim.diagnostic.severity.INFO]  = "I",
  [vim.diagnostic.severity.HINT]  = "H",
}

local severity_hl = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticError",
  [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
  [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
  [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
}

local function get_diagnostics(opts)
  local bufnr = opts.bufnr
  local severity = opts.severity
  local diags = {}

  if bufnr then
    local items = vim.diagnostic.get(bufnr, severity and { severity = severity } or nil)
    for _, d in ipairs(items) do
      d.bufnr = bufnr
      table.insert(diags, d)
    end
  else
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) then
        local items = vim.diagnostic.get(buf, severity and { severity = severity } or nil)
        for _, d in ipairs(items) do
          d.bufnr = buf
          table.insert(diags, d)
        end
      end
    end
  end

  -- Sort: severity first, then file, then line
  table.sort(diags, function(a, b)
    if a.severity ~= b.severity then return a.severity < b.severity end
    if a.bufnr ~= b.bufnr then return a.bufnr < b.bufnr end
    return a.lnum < b.lnum
  end)

  return diags
end

local function make_entry(diag)
  local fname = vim.api.nvim_buf_get_name(diag.bufnr)
  local short = vim.fn.fnamemodify(fname, ":~:.")
  local sev = severity_label[diag.severity] or "?"
  local display = string.format("[%s] %s:%d", sev, short, diag.lnum + 1)

  return {
    value = diag,
    display = display,
    ordinal = display,
    filename = fname,
    lnum = diag.lnum + 1,
    col = diag.col + 1,
    bufnr = diag.bufnr,
  }
end

--- Custom layout: left results, top-right preview, bottom-right message
local function create_layout(picker)
  local TSLayout = require("telescope.pickers.layout")
  local resolve = require("telescope.config.resolve")

  local function wincfg(enter, buf)
    return {
      enter = enter,
      border = true,
      bufnr = buf,
    }
  end

  local Layout = require("nui.layout")
  local Popup  = require("nui.popup")

  local results = Popup({
    focusable = false,
    border = { style = "rounded", text = { top = " Results ", top_align = "center" } },
    buf_options = { filetype = "TelescopeResults" },
    win_options = {
      winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
      cursorline = true,
    },
  })

  local preview = Popup({
    focusable = false,
    border = { style = "rounded", text = { top = " Preview ", top_align = "center" } },
    win_options = {
      winhighlight = "Normal:TelescopePreviewNormal,FloatBorder:TelescopeBorder",
    },
  })

  local prompt = Popup({
    enter = true,
    border = { style = "rounded", text = { top = " Diagnostics ", top_align = "center" } },
    win_options = {
      winhighlight = "Normal:TelescopeNormal,FloatBorder:TelescopeBorder",
    },
  })

  local message = Popup({
    focusable = false,
    border = { style = "rounded", text = { top = " Message ", top_align = "center" } },
    buf_options = { filetype = "markdown", modifiable = true },
    win_options = {
      winhighlight = "Normal:TelescopePreviewNormal,FloatBorder:TelescopeBorder",
      wrap = true,
    },
  })

  local layout = Layout(
    {
      position = "50%",
      size = { width = "95%", height = "95%" },
    },
    Layout.Box({
      Layout.Box({
        Layout.Box(prompt, { size = 3 }),
        Layout.Box(results, { grow = 1 }),
      }, { dir = "col", size = "30%" }),
      Layout.Box({
        Layout.Box(preview, { grow = 1 }),
        Layout.Box(message, { size = "30%" }),
      }, { dir = "col", grow = 1 }),
    }, { dir = "row" })
  )

  local tslayout = TSLayout {
    picker = picker,
    prompt = prompt,
    results = results,
    preview = preview,
  }

  -- Store message popup on the layout so we can update it
  tslayout._message_popup = message
  tslayout._nui_layout = layout

  function tslayout:mount()
    self._nui_layout:mount()
    -- Return proper window/buffer mappings for telescope
    return self
  end

  function tslayout:unmount()
    self._nui_layout:unmount()
  end

  -- Telescope expects these:
  function tslayout.update(self_) end

  return tslayout
end

local function open_diagnostics(opts)
  opts = opts or {}
  local diags = get_diagnostics(opts)

  if #diags == 0 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
    return
  end

  local message_buf = nil
  local message_win = nil

  local file_previewer = previewers.new_buffer_previewer({
    title = "Preview",
    define_preview = function(self, entry, status)
      conf.buffer_previewer_maker(entry.filename, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        callback = function(bufnr)
          -- Highlight the diagnostic line
          pcall(vim.api.nvim_buf_add_highlight, bufnr, 0, "Visual", entry.lnum - 1, 0, -1)
          -- Jump preview to the line
          pcall(function()
            vim.api.nvim_win_set_cursor(self.state.winid, { entry.lnum, entry.col - 1 })
            vim.api.nvim_win_call(self.state.winid, function()
              vim.cmd("normal! zz")
            end)
          end)
        end,
      })
    end,
  })

  local picker = pickers.new({}, {
    prompt_title = "Diagnostics",
    finder = finders.new_table({
      results = diags,
      entry_maker = make_entry,
    }),
    sorter = conf.generic_sorter({}),
    previewer = file_previewer,
    create_layout = create_layout,
    attach_mappings = function(prompt_bufnr, map)
      -- Update message panel on selection change
      local function update_message()
        vim.schedule(function()
          local entry = action_state.get_selected_entry()
          if not entry or not entry.value then return end

          local diag = entry.value
          local msg = diag.message or ""
          local source = diag.source or ""
          local code = diag.code and tostring(diag.code) or ""
          local sev = severity_label[diag.severity] or "?"

          local lines = {}
          table.insert(lines, string.format("**[%s]** %s", sev, source ~= "" and source or "unknown"))
          if code ~= "" then
            table.insert(lines, string.format("Code: `%s`", code))
          end
          table.insert(lines, "")
          for line in msg:gmatch("[^\n]+") do
            table.insert(lines, line)
          end

          -- Find the message popup buffer
          if message_buf and vim.api.nvim_buf_is_valid(message_buf) then
            vim.api.nvim_buf_set_option(message_buf, "modifiable", true)
            vim.api.nvim_buf_set_lines(message_buf, 0, -1, false, lines)
            vim.api.nvim_buf_set_option(message_buf, "modifiable", false)
          end
        end)
      end

      -- Hook into selection movement
      map("i", "<C-j>", function(bufnr)
        actions.move_selection_next(bufnr)
        update_message()
      end)
      map("i", "<C-k>", function(bufnr)
        actions.move_selection_previous(bufnr)
        update_message()
      end)
      map("i", "<Down>", function(bufnr)
        actions.move_selection_next(bufnr)
        update_message()
      end)
      map("i", "<Up>", function(bufnr)
        actions.move_selection_previous(bufnr)
        update_message()
      end)
      map("n", "j", function(bufnr)
        actions.move_selection_next(bufnr)
        update_message()
      end)
      map("n", "k", function(bufnr)
        actions.move_selection_previous(bufnr)
        update_message()
      end)

      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if entry then
          vim.cmd("edit " .. vim.fn.fnameescape(entry.filename))
          vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
          vim.cmd("normal! zz")
        end
      end)

      -- Initial message update after picker is rendered
      vim.defer_fn(update_message, 100)

      return true
    end,
  })

  picker:find()

  -- After the picker mounts, grab the message popup buffer
  vim.defer_fn(function()
    local layout = picker.layout
    if layout and layout._message_popup then
      message_buf = layout._message_popup.bufnr
      message_win = layout._message_popup.winid
    end
  end, 50)
end

return {
  open = open_diagnostics,
}

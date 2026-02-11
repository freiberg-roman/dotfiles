-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Terminal Toggle (<leader>t) ]]
-- Simple built-in terminal integration for quick commands.
-- Behavior:
--  * First <leader>t opens bottom terminal (height 15) focused & ready to type.
--  * <leader>t while focused closes it and returns to previous window.
--  * <leader>t from elsewhere jumps back (insert mode).
--  * Reuses single terminal buffer; avoids multiple accidental terminals.
--  * <Esc> leaves terminal mode; mapping works in normal & terminal modes.
local term_state = { buf = nil, win = nil, prev_win = nil }

local function term_is_valid()
  return term_state.buf and vim.api.nvim_buf_is_valid(term_state.buf) and vim.bo[term_state.buf].buftype == 'terminal'
end

local function focus_terminal()
  if term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
    vim.api.nvim_set_current_win(term_state.win)
  end
end

local function close_terminal()
  if term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
    vim.api.nvim_win_close(term_state.win, true)
  end
  term_state.win = nil
  if term_state.prev_win and vim.api.nvim_win_is_valid(term_state.prev_win) then
    vim.api.nvim_set_current_win(term_state.prev_win)
  end
  term_state.prev_win = nil
end

local function open_terminal()
  term_state.prev_win = vim.api.nvim_get_current_win()
  if term_is_valid() and term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
    focus_terminal()
  elseif term_is_valid() then
    vim.cmd('botright split')
    vim.cmd('resize 15')
    term_state.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(term_state.win, term_state.buf)
    focus_terminal()
  else
    vim.cmd('botright split')
    vim.cmd('resize 15')
    term_state.win = vim.api.nvim_get_current_win()
    vim.cmd('terminal')
    term_state.buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_name(term_state.buf, 'TermToggle')
    vim.keymap.set('t', '<Esc>', function()
      vim.api.nvim_feedkeys(vim.keycode([[<C-\><C-n>]]), 'n', false)
      vim.schedule(function() close_terminal() end)
    end, { buffer = term_state.buf, silent = true })
    focus_terminal()
  end
  vim.schedule(function()
    if term_is_valid() and term_state.win and vim.api.nvim_win_is_valid(term_state.win) and vim.api.nvim_get_current_win() == term_state.win then
      if vim.fn.mode() ~= 't' then
        vim.cmd('startinsert')
      end
    end
  end)
end

local function toggle_terminal()
  if term_state.win and vim.api.nvim_win_is_valid(term_state.win) and term_state.win == vim.api.nvim_get_current_win() then
    close_terminal(); return
  end
  if term_is_valid() and term_state.win and vim.api.nvim_win_is_valid(term_state.win) then
    term_state.prev_win = vim.api.nvim_get_current_win()
    focus_terminal(); return
  end
  open_terminal()
end

vim.keymap.set('n', '<leader>t', toggle_terminal, { desc = 'Toggle terminal' })

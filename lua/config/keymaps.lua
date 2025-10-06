-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>ut", ":TransparentToggle <CR>", { desc = "[T]oggle [T]ransparency" })
vim.keymap.set(
  "n",
  "<leader>l",
  ':lua require("nvterm.terminal").toggle "vertical" <CR>',
  { desc = "Toggle terminal vertical" }
)
vim.keymap.set(
  "n",
  "<leader>j",
  ':lua require("nvterm.terminal").toggle "horizontal" <CR>',
  { desc = "Toggle terminal horizontal" }
)

-- Toggle IPython terminal split
-- Global var to remember the ipython buffer id
local ipy_buf = nil

vim.keymap.set("n", "<leader>i", function()
  -- If we already have an ipython buffer
  if ipy_buf and vim.api.nvim_buf_is_valid(ipy_buf) then
    -- Check if it's visible in a window
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == ipy_buf then
        vim.api.nvim_win_close(win, true) -- close window showing ipython
        return
      end
    end
    -- Not visible, reopen it above
    vim.cmd("aboveleft 12split")
    vim.api.nvim_set_current_buf(ipy_buf)
    vim.cmd("startinsert")
    return
  end

  -- Otherwise, create a new ipython terminal above
  vim.cmd("aboveleft 12split")
  vim.cmd("terminal ipython")
  ipy_buf = vim.api.nvim_get_current_buf()
end, { noremap = true, silent = true, desc = "Toggle ipython" })

-- Send current line or motion to IPython
vim.keymap.set({ "n", "x" }, "<leader>I", function()
  if not ipy_buf or not vim.api.nvim_buf_is_valid(ipy_buf) then
    print("IPython terminal not open!")
    return
  end

  local start_line, end_line

  if vim.fn.mode() == "n" then
    -- Normal mode: send current line
    start_line = vim.fn.line(".")
    end_line = start_line
  else
    -- Visual mode: send selection
    start_line = vim.fn.line("v")
    end_line = vim.fn.line(".")
    if start_line > end_line then
      start_line, end_line = end_line, start_line
    end
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  for _, line in ipairs(lines) do
    vim.api.nvim_chan_send(vim.b[ipy_buf].terminal_job_id, line .. "\n")
  end
end, { noremap = true, silent = true, desc = "Send line/selection to IPython" })

-- vim.keymap.set("n", "<leader>k", function()
--   vim.cmd("split") -- make a horizontal split
--   vim.cmd("wincmd k") -- move to the upper window
--   vim.cmd("terminal ipython") -- start ipython in terminal
-- end)
-- vim.keymap.set("n", "<leader>e", ":Lexplore <CR>", { desc = "Default netrw" })

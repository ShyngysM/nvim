-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>ut", ":TransparentToggle <CR>", { desc = "[T]oggle [T]ransparency" })
-- vim.keymap.set("n", "<leader>e", ":Lexplore <CR>", { desc = "Default netrw" })

-- ========== Basic Settings ==========
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8

-- ========== Leader Key ==========
vim.g.mapleader = " "

-- ========== Keymaps ==========
local map = vim.keymap.set
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>s", ":split<CR>", { desc = "Horizontal split" })

-- ========== Buffer Shortcuts ==========
map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Close current buffer" })
map("n", "<leader>bl", ":ls<CR>", { desc = "List buffers" })
map("n", "<leader>bc", ":enew<CR>", { desc = "Create new buffer" })  -- NEW

-- Jump to buffer by number
map("n", "<leader>1", ":buffer 1<CR>")
map("n", "<leader>2", ":buffer 2<CR>")
map("n", "<leader>3", ":buffer 3<CR>")
map("n", "<leader>4", ":buffer 4<CR>")
map("n", "<leader>5", ":buffer 5<CR>")

-- ========== Simple Colorscheme ==========
vim.cmd("highlight Normal guibg=NONE")
vim.cmd("colorscheme desert")

-- ========== Basic Autocommands ==========
-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({timeout = 200})
  end,
})

-- ========== Terminal Mode Escape ==========
-- Map ESC to leave terminal mode
vim.api.nvim_set_keymap(
  "t",               -- terminal mode
  "<Esc>",           -- key
  "<C-\\><C-n>",     -- sequence to exit terminal mode
  { noremap = true, silent = true }
)


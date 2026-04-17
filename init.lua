-- Bootstrap lazy.nvim (minimalist plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
})




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
vim.opt.ignorecase = true    -- Ignore case when searching...
vim.opt.smartcase = true     -- ...unless you type a capital letter
vim.opt.inccommand = "split" -- Preview substitutions in a split window as you type!
vim.g.netrw_banner = 0       -- Hide that huge, ugly help banner
vim.g.netrw_liststyle = 3    -- Tree-style view
vim.g.netrw_winsize = 25     -- Window size 25%
-- ========== Leader Key ==========
vim.g.mapleader = " "

-- ========== Keymaps ==========
local map = vim.keymap.set
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>s", ":split<CR>", { desc = "Horizontal split" })
map("n", "<leader>e", ":Lexplore<CR>", { desc = "Toggle file explorer" })
map("n", "<C-h>", "<C-w>h") -- Move left
map("n", "<C-j>", "<C-w>j") -- Move down
map("n", "<C-k>", "<C-w>k") -- Move up
map("n", "<C-l>", "<C-w>l") -- Move right
-- ESC to clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear highlights" })

-- Move text up and down in Visual Mode
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")

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

-- Yank to windows clipboard
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = "win32yank-wsl",
    copy = {
      ["+"] = "win32yank.exe -i --crlf",
      ["*"] = "win32yank.exe -i --crlf",
    },
    paste = {
      ["+"] = "win32yank.exe -o --lf",
      ["*"] = "win32yank.exe -o --lf",
    },
    cache_enabled = 0,
  }
end

-- This ensures that 'y' in Neovim automatically hits the Windows clipboard
vim.opt.clipboard = "unnamedplus"

-- LSP --
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls" } -- Add more servers here (e.g., "pyright", "tsserver")
})

local lspconfig = require('lspconfig')
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

-- Setup specifically for Lua (for your config!)
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
})

-- ========================================================================== --
-- ==                           PLUGIN MANAGER                             == --
-- ========================================================================== --
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

-- ========================================================================== --
-- ==                            BASIC SETTINGS                            == --
-- ========================================================================== --
vim.g.mapleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.wrap = false
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.ignorecase = true    -- Case-insensitive search
opt.smartcase = true     -- Case-sensitive if capitals used
opt.inccommand = "split" -- Live preview of substitutions
opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Netrw (Built-in File Explorer)
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 25

-- ========================================================================== --
-- ==                               KEYMAPS                                == --
-- ========================================================================== --
local map = vim.keymap.set

-- General
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Quit" })
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear highlights" })
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>")

-- Window Management
map("n", "<leader>v", ":vsplit<CR>", { desc = "Vertical split" })
map("n", "<leader>s", ":split<CR>", { desc = "Horizontal split" })
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- File Explorer
map("n", "<leader>e", ":Lexplore<CR>", { desc = "Toggle Explorer" })

-- Visual Mode: Move lines
map("v", "K", ":m '<-2<CR>gv=gv")
map("v", "J", ":m '>+1<CR>gv=gv")

-- Buffers
map("n", "<leader>bn", ":bnext<CR>")
map("n", "<leader>bp", ":bprevious<CR>")
map("n", "<leader>bd", ":bdelete<CR>")
map("n", "<leader>bl", ":ls<CR>")
map("n", "<leader>bc", ":enew<CR>")

for i = 1, 5 do
  map("n", "<leader>" .. i, ":buffer " .. i .. "<CR>")
end

-- Terminal
map("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

-- ========================================================================== --
-- ==                             AUTOCOMMANDS                             == --
-- ========================================================================== --
local group = vim.api.nvim_create_augroup("CustomConfigs", { clear = true })

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  pattern = "*",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- ========================================================================== --
-- ==                             WSL CLIPBOARD                            == --
-- ========================================================================== --
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

-- ========================================================================== --
-- ==                                 LSP                                  == --
-- ========================================================================== --
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls" }
})

local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  map('n', 'gd', vim.lsp.buf.definition, opts)
  map('n', 'K', vim.lsp.buf.hover, opts)
  map('n', '<leader>rn', vim.lsp.buf.rename, opts)
  map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  map('n', 'gr', vim.lsp.buf.references, opts)
end

-- LSP Config (Future-proof for 0.11+)
if vim.lsp.config then
  vim.lsp.config("lua_ls", {
    on_attach = on_attach,
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
  })
  vim.lsp.enable("lua_ls")
else
  -- Fallback for older versions
  require('lspconfig').lua_ls.setup({
    on_attach = on_attach,
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
  })
end

-- ========================================================================== --
-- ==                              COLORSCHEME                             == --
-- ========================================================================== --
vim.cmd("colorscheme desert")
vim.cmd("highlight Normal guibg=NONE")

-- ========================================================================== --
-- ==                           CUSTOM STATUSLINE                          == --
-- ========================================================================== --
local function statusline()
  local set_color_1 = "%#PmenuSel#"  -- Highlights for the mode/file
  local set_color_2 = "%#LineNr#"    -- Highlights for the path/info
  local reset_color = "%*"           -- Reset highlight

  return table.concat({
    set_color_1,
    " %f ",                          -- File path
    set_color_2,
    " %m%r%h%w ",                    -- Modified, Read-only, Help, Preview flags
    reset_color,
    "%= ",                           -- Right align starts here
    set_color_2,
    " %y ",                          -- File type
    " %p%% ",                        -- Percentage through file
    set_color_1,
    " %l:%c ",                       -- Line:Column
    " "
  })
end

vim.opt.statusline = statusline()
-- Always show the statusline
vim.opt.laststatus = 2

-- Core Neovim options
local opt = vim.opt
local g = vim.g

-- Set to true if you have a Nerd Font installed
g.have_nerd_font = true

-- UI
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 10
opt.signcolumn = 'yes'
opt.showmode = false
opt.list = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
opt.pumheight = 10 -- Limit completion menu height
opt.completeopt = 'menuone,noselect,preview' -- Better completion experience

-- Persistent undo
opt.undodir = vim.fn.expand('$HOME') .. '/.vim/undodir'
opt.undofile = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = 'split'

-- Windows
opt.splitright = true
opt.splitbelow = true

-- System
opt.mouse = 'a'
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Responsiveness
opt.updatetime = 250
opt.timeoutlen = 300

-- Diagnostics configuration
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Add borders to floating windows
local _border = 'rounded'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = _border,
})

-- Set GIT_EDITOR to use nvr if Neovim and nvr are available
if vim.fn.has('nvim') == 1 and vim.fn.executable('nvr') == 1 then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end

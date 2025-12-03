-- Near-Vanilla Neovim for TypeScript/Next.js
-- 5 plugins, sub-30ms startup

--------------------------------------------------------------------------------
-- LEADER
--------------------------------------------------------------------------------
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--------------------------------------------------------------------------------
-- OPTIONS
--------------------------------------------------------------------------------
local opt = vim.opt

-- Performance
opt.updatetime = 200
opt.timeoutlen = 300

-- Visual
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.cursorline = true
opt.cursorlineopt = 'number'
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.showmode = false
opt.laststatus = 3

-- Editing
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = 'split'

-- Files
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Completion
opt.completeopt = 'menu,menuone,noselect'
opt.pumheight = 10

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Clipboard
opt.clipboard = 'unnamedplus'

--------------------------------------------------------------------------------
-- DISABLE BUILT-IN PLUGINS
--------------------------------------------------------------------------------
local disabled = {
  'gzip', 'zip', 'zipPlugin', 'tar', 'tarPlugin',
  'getscript', 'getscriptPlugin', 'vimball', 'vimballPlugin',
  '2html_plugin', 'matchit', 'matchparen', 'logiPat', 'rrhelper',
  'netrw', 'netrwPlugin', 'netrwSettings', 'netrwFileHandlers',
}
for _, plugin in ipairs(disabled) do
  vim.g['loaded_' .. plugin] = 1
end

--------------------------------------------------------------------------------
-- KEYMAPS
--------------------------------------------------------------------------------
local map = vim.keymap.set

-- Clear search
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Window navigation
map('n', '<C-h>', '<C-w>h')
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')

-- Better up/down
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Quickfix
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Quickfix list' })

-- Terminal escape
map('t', '<Esc><Esc>', '<C-\\><C-n>')

--------------------------------------------------------------------------------
-- AUTOCOMMANDS
--------------------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd('TextYankPost', {
  group = augroup('highlight_yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Return to last position
autocmd('BufReadPost', {
  group = augroup('last_position', { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close help/qf with q
autocmd('FileType', {
  group = augroup('close_with_q', { clear = true }),
  pattern = { 'help', 'qf', 'lspinfo', 'man', 'checkhealth' },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    map('n', 'q', '<cmd>close<cr>', { buffer = ev.buf })
  end,
})

--------------------------------------------------------------------------------
-- DIAGNOSTICS
--------------------------------------------------------------------------------
vim.diagnostic.config({
  virtual_text = { prefix = '●', spacing = 4 },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
})

--------------------------------------------------------------------------------
-- LSP (Neovim 0.11 native)
--------------------------------------------------------------------------------
autocmd('LspAttach', {
  group = augroup('lsp_attach', { clear = true }),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    map('n', 'gd', vim.lsp.buf.definition, opts)
    map('n', 'gD', vim.lsp.buf.declaration, opts)
    map('n', 'K', vim.lsp.buf.hover, opts)
    -- grn, gra, grr, gri, gO, <C-s> are built-in defaults in 0.11
  end,
})

-- Enable TypeScript LSP
vim.lsp.enable('vtsls')

--------------------------------------------------------------------------------
-- PLUGINS (5 total)
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- 1. COMPLETION
  {
    'saghen/blink.cmp',
    version = 'v0.*',
    event = 'InsertEnter',
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      sources = { default = { 'lsp', 'path', 'buffer' } },
      completion = { documentation = { auto_show = true } },
    },
  },

  -- 2. FUZZY FINDER
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    cmd = 'Telescope',
    keys = {
      { '<leader>sf', '<cmd>Telescope find_files<cr>', desc = 'Find files' },
      { '<leader>sg', '<cmd>Telescope live_grep<cr>', desc = 'Live grep' },
      { '<leader><leader>', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
      { '<leader>/', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Search buffer' },
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git/', 'dist/', '.next/' },
      },
    },
  },

  -- 3. SYNTAX
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = { 'typescript', 'tsx', 'javascript', 'json', 'html', 'css', 'lua', 'markdown' },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- 4. FORMATTING
  {
    'stevearc/conform.nvim',
    event = 'BufWritePre',
    keys = {
      { '<leader>f', function() require('conform').format({ async = true }) end, desc = 'Format' },
    },
    opts = {
      formatters_by_ft = {
        typescript = { 'biome' },
        typescriptreact = { 'biome' },
        javascript = { 'biome' },
        javascriptreact = { 'biome' },
        json = { 'biome' },
        jsonc = { 'biome' },
        css = { 'biome' },
        lua = { 'stylua' },
      },
      format_on_save = { timeout_ms = 500, lsp_format = 'fallback' },
    },
  },

  -- 5. EDITING
  {
    'echasnovski/mini.surround',
    event = 'VeryLazy',
    opts = {},
  },

  -- COLORSCHEME
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        transparent = true,
        terminal_colors = true,
      })
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}, {
  defaults = { lazy = true },
  performance = {
    cache = { enabled = true },
    rtp = { disabled_plugins = disabled },
  },
  checker = { enabled = false },
  change_detection = { notify = false },
})

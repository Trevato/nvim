-- Core options for exceptional UX
-- Inspired by Apple HIG, Dieter Rams, and elite Neovim configs

local opt = vim.opt
local g = vim.g

-- Set to true if you have a Nerd Font installed
g.have_nerd_font = true

-- Performance First
opt.updatetime = 200 -- Faster completion and hover
opt.timeoutlen = 300 -- Faster key sequence completion
opt.redrawtime = 100 -- Faster redraw

-- Invisible Interface (Dieter Rams: Good design is unobtrusive)
opt.laststatus = 3 -- Global statusline (one bar for all windows)
opt.cmdheight = 1 -- Will be 0 with Noice.nvim
opt.showmode = false -- Don't show mode (statusline handles this)
opt.showcmd = false -- Don't show command in bottom line
opt.ruler = false -- Don't show cursor position

-- Clean Editor
opt.number = true -- Show line numbers
opt.relativenumber = true -- Relative line numbers for easy jumps
opt.signcolumn = 'yes' -- Always show sign column (no shifting)
opt.colorcolumn = '' -- No color column by default
opt.wrap = false -- Don't wrap lines
opt.linebreak = true -- Break at word boundaries when wrap is on
opt.cursorline = true -- Highlight current line subtly
opt.cursorlineopt = 'number' -- Only highlight line number

-- Smooth Experience (Bret Victor: Immediate feedback)
opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns visible left/right
opt.smoothscroll = true -- Smooth scrolling (Neovim 0.10+)

-- Better Colors
opt.termguicolors = true -- True color support
opt.pumblend = 10 -- Slight transparency for popup menu
opt.winblend = 0 -- No transparency for windows by default

-- Smart Behavior
opt.ignorecase = true -- Case insensitive search
opt.smartcase = true -- Unless uppercase is used
opt.smartindent = true -- Smart auto-indenting
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- 2 spaces for indent
opt.tabstop = 2 -- 2 spaces for tab
opt.shiftround = true -- Round indent to multiple of shiftwidth

-- Search
opt.incsearch = true -- Show search results as you type
opt.hlsearch = true -- Highlight search results
opt.inccommand = 'split' -- Show substitution results in split

-- File Management
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup before overwriting
opt.swapfile = false -- Don't use swapfile
opt.undofile = true -- Persistent undo
opt.undolevels = 10000 -- Maximum undo levels
opt.undodir = vim.fn.expand('$HOME') .. '/.vim/undodir'

-- Better Completion Experience
opt.completeopt = 'menu,menuone,noselect,preview' -- Better completion UX
opt.pumheight = 10 -- Maximum items in popup menu

-- Window Management
opt.splitbelow = true -- Horizontal splits below
opt.splitright = true -- Vertical splits to the right
opt.splitkeep = 'screen' -- Keep screen position when splitting
opt.winminwidth = 5 -- Minimum window width

-- Visual Feedback
opt.conceallevel = 2 -- Conceal some syntax (markdown, etc)
opt.list = true -- Show some invisible characters
opt.listchars = { -- Make them subtle
  tab = '  ',
  trail = '·',
  extends = '→',
  precedes = '←',
  nbsp = '␣',
}
opt.fillchars = {
  foldopen = '▾',
  foldclose = '▸',
  fold = ' ',
  foldsep = ' ',
  diff = '╱',
  eob = ' ', -- Hide ~ at end of buffer
}

-- System Integration
opt.mouse = 'a' -- Enable mouse support
opt.mousemoveevent = true -- Mouse move events for hover
vim.schedule(function()
  opt.clipboard = 'unnamedplus' -- System clipboard
end)

-- Sessions (for auto-session)
opt.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'

-- Fold (keep it simple)
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldlevel = 99 -- Start with all folds open
opt.foldenable = false -- Don't fold by default

-- Diagnostics (subtle and helpful)
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

-- Better floating windows
local _border = 'rounded'
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = _border,
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = _border,
})

-- Leader key
g.mapleader = ' '
g.maplocalleader = ' '

-- Disable netrw (we'll use Oil.nvim)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Performance: Disable some built-in plugins
local disabled_built_ins = {
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'matchit',
  'matchparen',
  'logiPat',
  'rrhelper',
  'sql_completion',
}

for _, plugin in pairs(disabled_built_ins) do
  g['loaded_' .. plugin] = 1
end

-- Set GIT_EDITOR to use nvr if available
if vim.fn.has('nvim') == 1 and vim.fn.executable('nvr') == 1 then
  vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
end
-- Autocommands
local api = vim.api

-- Highlight when yanking (copying) text
api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Performance monitoring
api.nvim_create_autocmd('User', {
  pattern = 'LazyVimStarted',
  callback = function()
    local stats = require('lazy').stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    print('⚡ Neovim loaded ' .. stats.count .. ' plugins in ' .. ms .. 'ms')
  end,
})

-- Auto-resize splits when window is resized
api.nvim_create_autocmd('VimResized', {
  group = api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
  end,
})

-- Close certain filetypes with q
api.nvim_create_autocmd('FileType', {
  group = api.nvim_create_augroup('close_with_q', { clear = true }),
  pattern = {
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'query',
    'startuptime',
    'tsplayground',
    'checkhealth',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- Go to last location when opening a file
api.nvim_create_autocmd('BufReadPost', {
  group = api.nvim_create_augroup('last_location', { clear = true }),
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local lcount = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Dynamic window title updates
api.nvim_create_autocmd('BufEnter', {
  group = api.nvim_create_augroup('update_window_title', { clear = true }),
  callback = function()
    local filepath = vim.fn.expand('%:.')
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

    if filepath == '' then
      filepath = '[No Name]'
    end

    local modified = vim.bo.modified and ' [+]' or ''
    local title = string.format('nvim:%s/%s%s', project_name, filepath, modified)

    -- Handle special buffers
    local buftype = vim.bo.buftype
    if buftype == 'help' then
      title = string.format('nvim:%s/help', project_name)
    elseif buftype == 'terminal' then
      title = string.format('nvim:%s/terminal', project_name)
    elseif buftype == 'quickfix' then
      title = string.format('nvim:%s/quickfix', project_name)
    end

    vim.opt.titlestring = title
  end,
})

-- LSP autocmds are in the lsp.lua file to keep related code together

-- Note: snacks.nvim image viewer automatically registers BufReadCmd autocmds
-- when enabled, so no manual autocmd needed here
-- Note: Python-specific settings are now in ftplugin/python.lua

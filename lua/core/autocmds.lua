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
api.nvim_create_autocmd({ 'BufEnter', 'BufModifiedSet', 'BufWritePost', 'DirChanged' }, {
  group = api.nvim_create_augroup('update_window_title', { clear = true }),
  callback = function()
    local filename = vim.fn.expand('%:t')
    local filepath = vim.fn.expand('%:.')  -- Relative to working directory

    -- Get the project directory name
    local cwd = vim.fn.getcwd()
    local project_name = vim.fn.fnamemodify(cwd, ':t')

    if filename == '' then
      filename = '[No Name]'
      filepath = '[No Name]'
    end

    local modified = vim.bo.modified and ' [+]' or ''

    -- Format: nvim:project/relative/path/to/file
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

-- Python-specific keybindings and settings
api.nvim_create_autocmd('FileType', {
  group = api.nvim_create_augroup('python_settings', { clear = true }),
  pattern = 'python',
  callback = function()
    -- Set Python-specific options
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.textwidth = 88 -- Black/Ruff default line length
    
    -- Python-specific keybindings
    local opts = { buffer = true, silent = true }
    
    -- Quick imports
    vim.keymap.set('n', '<leader>pi', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { 'source.organizeImports' },
        },
      })
    end, vim.tbl_extend('force', opts, { desc = 'Organize imports' }))
    
    -- Python debugging helpers
    vim.keymap.set('n', '<leader>pb', 'obreakpoint()<Esc>', vim.tbl_extend('force', opts, { desc = 'Insert breakpoint()' }))
    vim.keymap.set('n', '<leader>pB', 'Obreakpoint()<Esc>', vim.tbl_extend('force', opts, { desc = 'Insert breakpoint() above' }))
    
    -- Quick print statement
    vim.keymap.set('n', '<leader>pp', 'oprint(f"{=}")<Esc>2F{a', vim.tbl_extend('force', opts, { desc = 'Insert print statement' }))
    vim.keymap.set('v', '<leader>pp', 'yoprint(f"<C-r>": {<C-r>"=}")<Esc>', vim.tbl_extend('force', opts, { desc = 'Print selection' }))
    
    -- Type annotations
    vim.keymap.set('n', '<leader>pt', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { 'source.addMissingImports', 'source.fixMissingImports' },
        },
      })
    end, vim.tbl_extend('force', opts, { desc = 'Add type imports' }))
  end,
})

-- Debug helpers for troubleshooting configuration issues
local M = {}

-- Function to show recent errors
M.show_errors = function()
  local messages = require('notify').history()
  local errors = {}
  
  for _, msg in ipairs(messages) do
    if msg.level == vim.log.levels.ERROR or msg.level == vim.log.levels.WARN then
      table.insert(errors, {
        title = msg.title or 'Error',
        message = table.concat(msg.message, '\n'),
        level = msg.level
      })
    end
  end
  
  if #errors == 0 then
    vim.notify('No recent errors found', vim.log.levels.INFO)
  else
    for _, err in ipairs(errors) do
      print(string.format('[%s] %s: %s', 
        err.level == vim.log.levels.ERROR and 'ERROR' or 'WARN',
        err.title,
        err.message))
    end
  end
end

-- Function to copy errors to clipboard
M.copy_errors = function()
  local messages = require('notify').history()
  local errors = {}
  
  -- Collect errors and warnings
  for _, msg in ipairs(messages) do
    if msg.level == vim.log.levels.ERROR or msg.level == vim.log.levels.WARN then
      local level_str = msg.level == vim.log.levels.ERROR and 'ERROR' or 'WARN'
      local title = msg.title or 'Unknown'
      local message = table.concat(msg.message, '\n')
      table.insert(errors, string.format('[%s] %s\n%s', level_str, title, message))
    end
  end
  
  -- Also get diagnostics
  local diagnostics = vim.diagnostic.get()
  if #diagnostics > 0 then
    table.insert(errors, '\n=== Diagnostics ===')
    for _, d in ipairs(diagnostics) do
      local severity = vim.diagnostic.severity[d.severity]
      table.insert(errors, string.format('[%s] %s:%d:%d %s',
        severity,
        vim.fn.fnamemodify(vim.api.nvim_buf_get_name(d.bufnr), ':~:.'),
        d.lnum + 1,
        d.col + 1,
        d.message
      ))
    end
  end
  
  if #errors == 0 then
    vim.notify('No errors to copy', vim.log.levels.INFO)
  else
    local error_text = table.concat(errors, '\n\n')
    vim.fn.setreg('+', error_text)
    vim.fn.setreg('*', error_text)
    vim.notify('Copied ' .. #errors .. ' error(s) to clipboard', vim.log.levels.INFO)
  end
end

-- Function to copy ALL notifications to clipboard (not just errors)
M.copy_notifications = function()
  local messages = require('notify').history()
  local all_messages = {}
  
  -- Collect ALL notification messages
  for _, msg in ipairs(messages) do
    local level_str = ({
      [vim.log.levels.ERROR] = 'ERROR',
      [vim.log.levels.WARN] = 'WARN',
      [vim.log.levels.INFO] = 'INFO',
      [vim.log.levels.DEBUG] = 'DEBUG',
      [vim.log.levels.TRACE] = 'TRACE',
    })[msg.level] or 'UNKNOWN'
    
    -- Handle title being a table or string
    local title = 'Notification'
    if type(msg.title) == 'string' then
      title = msg.title
    elseif type(msg.title) == 'table' and msg.title[1] then
      title = tostring(msg.title[1])
    end
    
    -- Handle message being a table or string
    local message = ''
    if type(msg.message) == 'table' then
      message = table.concat(msg.message, '\n')
    elseif type(msg.message) == 'string' then
      message = msg.message
    end
    
    table.insert(all_messages, string.format('[%s] %s\n%s', level_str, title, message))
  end
  
  if #all_messages == 0 then
    vim.notify('No notifications to copy', vim.log.levels.INFO)
  else
    local messages_text = table.concat(all_messages, '\n\n---\n\n')
    vim.fn.setreg('+', messages_text)
    vim.fn.setreg('*', messages_text)
    vim.notify('Copied ' .. #all_messages .. ' notification(s) to clipboard', vim.log.levels.INFO)
  end
end

-- Function to check plugin status
M.check_plugins = function()
  local lazy = require('lazy')
  local stats = lazy.stats()
  local plugins = lazy.plugins()
  
  print(string.format('Loaded %d plugins in %.2fms', stats.count, stats.startuptime))
  print('\nPlugin issues:')
  
  local has_issues = false
  for _, plugin in pairs(plugins) do
    if plugin._.loaded and plugin._.loaded.err then
      print(string.format('  ✗ %s: %s', plugin.name, plugin._.loaded.err))
      has_issues = true
    end
  end
  
  if not has_issues then
    print('  ✓ All plugins loaded successfully')
  end
end

-- Function to test LSP servers
M.check_lsp = function()
  local clients = vim.lsp.get_active_clients()
  if #clients == 0 then
    print('No active LSP clients')
  else
    print('Active LSP clients:')
    for _, client in ipairs(clients) do
      print(string.format('  • %s (id: %d)', client.name, client.id))
    end
  end
end

-- Create user commands
vim.api.nvim_create_user_command('DebugErrors', M.show_errors, { desc = 'Show recent errors' })
vim.api.nvim_create_user_command('DebugPlugins', M.check_plugins, { desc = 'Check plugin status' })
vim.api.nvim_create_user_command('DebugLSP', M.check_lsp, { desc = 'Check LSP status' })
vim.api.nvim_create_user_command('CopyErrors', M.copy_errors, { desc = 'Copy all errors to clipboard' })
vim.api.nvim_create_user_command('CopyNotifications', M.copy_notifications, { desc = 'Copy ALL notifications to clipboard' })

-- Comprehensive debug info
vim.api.nvim_create_user_command('DebugInfo', function()
  print('=== Neovim Debug Info ===\n')
  M.check_plugins()
  print('\n')
  M.check_lsp()
  print('\n')
  M.show_errors()
end, { desc = 'Show comprehensive debug information' })

return M
-- Global keymaps that aren't plugin-specific
local keymap = vim.keymap.set

-- Clear highlights on search when pressing <Esc> in normal mode
keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Format buffer
keymap('n', '<leader>f', function()
  require('conform').format { async = true, lsp_fallback = true }
end, { desc = '[F]ormat buffer' })

-- Exit terminal mode with Esc-Esc
keymap('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys to encourage using hjkl
keymap('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
keymap('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
keymap('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
keymap('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Huefy color picker
keymap('n', '<leader>th', '<cmd>Huefy<CR>', { desc = '[T]oggle [H]uefy color picker' })

-- Window navigation
keymap('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Notification management
keymap('n', '<leader>un', function()
  require('notify').dismiss({ silent = true, pending = true })
end, { desc = 'Dismiss all notifications' })

keymap('n', '<leader>uN', function()
  require('telescope').extensions.notify.notify()
end, { desc = 'Search [N]otifications history' })

-- Error management
keymap('n', '<leader>ue', function()
  require('core.debug').copy_errors()
end, { desc = 'Copy [E]rrors to clipboard' })

keymap('n', '<leader>ua', function()
  require('core.debug').copy_notifications()
end, { desc = 'Copy [A]ll notifications to clipboard' })


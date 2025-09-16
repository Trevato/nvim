-- Main plugin specification file
-- Imports all other plugin category files

return {
  -- Core plugins needed by others
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim', -- UI component library
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'nvim-tree/nvim-web-devicons',
  
  -- Import all plugin categories
  { import = 'plugins.theme' }, -- Load theme first
  { import = 'plugins.ui' },
  { import = 'plugins.ux' }, -- Revolutionary UX enhancements
  { import = 'plugins.editor' },
  { import = 'plugins.navigation' },
  { import = 'plugins.completion' },
  { import = 'plugins.lsp' },
  { import = 'plugins.lsp-memory' }, -- LSP memory management
  { import = 'plugins.git' },
  { import = 'plugins.tools' },
  { import = 'plugins.python' }, -- Python development
  { import = 'plugins.focus' }, -- Focus mode & sessions
  { import = 'plugins.animations' }, -- Subtle animations
  { import = 'plugins.notifications' }, -- Enhanced notifications
  { import = 'plugins.performance' }, -- Performance optimizations
  { import = 'plugins.performance-monitor' }, -- Performance monitoring
  { import = 'plugins.music' }, -- Strudel live coding (conditional)
}

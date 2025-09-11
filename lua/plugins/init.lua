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
  { import = 'plugins.editor' },
  { import = 'plugins.navigation' },
  { import = 'plugins.completion' },
  { import = 'plugins.lsp' },
  { import = 'plugins.git' },
  { import = 'plugins.tools' },
}

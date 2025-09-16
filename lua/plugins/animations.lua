-- Stable, subtle animations that enhance without distraction
return {
  
  -- Highlight yanked text
  {
    'machakann/vim-highlightedyank',
    event = 'TextYankPost',
    config = function()
      vim.g.highlightedyank_highlight_duration = 200
      vim.api.nvim_set_hl(0, 'HighlightedyankRegion', { bg = '#ff007c', fg = '#000000' })
    end,
  },
  
  -- Note: mini.indentscope is configured in ux.lua with more comprehensive settings
  
  -- Cursor word highlighting
  {
    'RRethy/vim-illuminate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('illuminate').configure({
        delay = 200,
        large_file_cutoff = 2000,
        min_count_to_highlight = 2,
      })
      
      vim.api.nvim_set_hl(0, 'IlluminatedWordText', { bg = '#2a3a4a' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordRead', { bg = '#2a3a4a' })
      vim.api.nvim_set_hl(0, 'IlluminatedWordWrite', { bg = '#3a2a3a' })
    end,
  },
}
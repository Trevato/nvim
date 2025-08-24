-- Stable, subtle animations that enhance without distraction
return {
  -- Smooth scrolling only
  {
    'karb94/neoscroll.nvim',
    event = 'VeryLazy',
    config = function()
      require('neoscroll').setup({
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>' },
        hide_cursor = false,
        stop_eof = true,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = 'cubic',
      })
    end,
  },
  
  -- Highlight yanked text
  {
    'machakann/vim-highlightedyank',
    event = 'TextYankPost',
    config = function()
      vim.g.highlightedyank_highlight_duration = 200
      vim.api.nvim_set_hl(0, 'HighlightedyankRegion', { bg = '#ff007c', fg = '#000000' })
    end,
  },
  
  -- Indent scope animation
  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      symbol = '│',
      options = { try_as_border = true },
      draw = {
        delay = 100,
        animation = function(s, n) return 20 end,
      },
    },
  },
  
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
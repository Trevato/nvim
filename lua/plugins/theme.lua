-- Theme and visual settings
return {
  -- TokyoNight theme (primary)
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        transparent = true,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { bold = true },
          functions = {},
          variables = {},
          sidebars = 'transparent',
          floats = 'transparent',
        },
        on_colors = function(colors)
          colors.bg_highlight = '#1a1b26'
        end,
        on_highlights = function(highlights, colors)
          highlights.LineNr = { fg = colors.dark3 }
          highlights.CursorLineNr = { fg = colors.orange, bold = true }
        end,
      })
      
      -- Apply the colorscheme
      vim.cmd.colorscheme('tokyonight')
    end,
  },
  
  -- Alpine theme (if you want to use your custom theme)
  {
    'trevato/alpine.nvim',
    lazy = true,
    priority = 900,
    config = function()
      require('alpine').setup({
        transparent = true,
        italic_comments = true,
        bold_keywords = true,
        integrations = {
          treesitter = true,
          telescope = true,
          nvimtree = true,
          lsp = true,
          noice = true,
          notify = true,
        },
      })
    end,
  },
  
  -- Color tools
  {
    'nvzone/minty',
    cmd = { 'Shades', 'Huefy' },
  },
  
  { 'nvzone/volt', lazy = true },
}

-- Theme and visual settings
return {
  -- Your custom Alpine theme
  {
    'trevato/alpine.nvim',
    dir = '/users/trevato/projects/alpine.nvim',
    lazy = false,
    priority = 1000,
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
        },
      })
    end,
  },
  
  -- Fallback theme in case Alpine isn't available
  {
    'folke/tokyonight.nvim',
    priority = 900,
    lazy = true,
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
          sidebars = 'dark',
          floats = 'dark',
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

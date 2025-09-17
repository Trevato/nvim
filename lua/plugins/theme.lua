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

          -- Make WinBar transparent with nice border
          highlights.WinBar = { bg = 'NONE', fg = colors.fg_sidebar }
          highlights.WinBarNC = { bg = 'NONE', fg = colors.dark3 }

          -- Make StatusLine transparent
          highlights.StatusLine = { bg = 'NONE', fg = colors.fg_sidebar }
          highlights.StatusLineNC = { bg = 'NONE', fg = colors.dark3 }

          -- Make treesitter-context transparent (the bar above winbar)
          highlights.TreesitterContext = { bg = 'NONE', fg = colors.fg_sidebar }
          highlights.TreesitterContextLineNumber = { bg = 'NONE', fg = colors.dark3 }

          -- Make TabLine transparent (remove the bar at the top)
          highlights.TabLine = { bg = 'NONE', fg = colors.dark3 }
          highlights.TabLineFill = { bg = 'NONE' }
          highlights.TabLineSel = { bg = 'NONE', fg = colors.blue, bold = true }
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

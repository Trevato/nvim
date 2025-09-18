-- Which-key for displaying keybindings
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+',
    },
    window = {
      border = 'rounded',
      position = 'bottom',
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
      winblend = 0,
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = 'left',
    },
  },
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)

    -- Register groups
    wk.register({
      ['<leader>'] = {
        c = { name = 'Code' },
        d = { name = 'Debug' },
        f = { name = 'Format' },
        g = { name = 'Git' },
        h = { name = 'Hunk' },
        p = { name = 'Python' },
        r = { name = 'Rename/Refactor' },
        s = { name = 'Search' },
        t = { name = 'Terminal' },
        T = { name = 'Test' },
        u = { name = 'UI/Utilities' },
        x = { name = 'Trouble/Diagnostics' },
      },
    })
  end,
}
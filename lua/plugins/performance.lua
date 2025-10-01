-- Performance optimizations for blazing fast Neovim
return {

  -- Profile startup time
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Faster file operations
  {
    'nvim-lua/plenary.nvim',
    lazy = false, -- Many plugins depend on this
  },

  -- Note: Using snacks.nvim bigfile functionality instead of standalone bigfile.nvim
  -- to avoid conflicts and reduce plugin count




  -- Defer plugin loading
  {
    'folke/lazy.nvim',
    config = function()
      -- This is already configured in your main config
      -- Adding performance settings here for reference
      local lazy_opts = {
        performance = {
          cache = {
            enabled = true,
          },
          reset_packpath = true,
          rtp = {
            reset = true,
            paths = {},
            disabled_plugins = {
              'gzip',
              'matchit',
              'matchparen',
              'netrwPlugin',
              'tarPlugin',
              'tohtml',
              'tutor',
              'zipPlugin',
            },
          },
        },
      }
    end,
  },

  -- Snacks.nvim - Modern utilities (performance-optimized)
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = false, -- Using noice.nvim + nvim-notify instead
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false }, -- We have our own
      words = { enabled = true },
      image = { enabled = true }, -- Image viewer for Ghostty with Kitty Graphics Protocol
      dashboard = {
        enabled = false, -- Using alpha-nvim for personalized dashboard
      },
      terminal = {
        enabled = true,
        win = {
          position = 'bottom',
          height = 0.3,
          border = 'rounded',
        },
      },
      indent = {
        enabled = false, -- Using mini.indentscope
      },
      scope = {
        enabled = false, -- Using mini.indentscope
      },
      scroll = {
        enabled = false, -- Using neoscroll
      },
      animate = {
        enabled = false, -- Minimal animations only
      },
    },
    config = function(_, opts)
      require('snacks').setup(opts)
      
      -- Set up keymaps for snacks features
      vim.keymap.set('n', '<leader>gg', function() require('snacks').terminal.toggle('lazygit') end, { desc = 'LazyGit' })
      vim.keymap.set('n', '<leader>tt', function() require('snacks').terminal.toggle() end, { desc = 'Toggle Terminal' })
      vim.keymap.set('n', '<leader>t1', function() require('snacks').terminal.toggle(nil, { id = 1 }) end, { desc = 'Terminal 1' })
      vim.keymap.set('n', '<leader>t2', function() require('snacks').terminal.toggle(nil, { id = 2 }) end, { desc = 'Terminal 2' })
      vim.keymap.set('n', '<leader>t3', function() require('snacks').terminal.toggle(nil, { id = 3 }) end, { desc = 'Terminal 3' })
      vim.keymap.set('n', '<leader>tf', function() require('snacks').terminal.toggle(nil, { win = { position = 'float' }}) end, { desc = 'Floating Terminal' })
      -- Note: <leader>un for dismiss notifications is defined in core/keymaps.lua with snacks fallback
    end,
  },

  -- Cache everything possible
  {
    'nvim-telescope/telescope-frecency.nvim',
    dependencies = { 'kkharji/sqlite.lua' },
    config = function()
      require('telescope').load_extension('frecency')
    end,
  },

  -- Better undo with compression
  {
    'kevinhwang91/nvim-fundo',
    dependencies = 'kevinhwang91/promise-async',
    build = function()
      require('fundo').install()
    end,
    config = function()
      require('fundo').setup()
    end,
  },

  -- Smart buffer deletion (keep window layout)
  {
    'famiu/bufdelete.nvim',
    cmd = { 'Bdelete', 'Bwipeout' },
    keys = {
      { '<leader>bd', '<cmd>Bdelete<cr>', desc = 'Delete Buffer' },
      { '<leader>bD', '<cmd>Bdelete!<cr>', desc = 'Delete Buffer (Force)' },
    },
  },

}
-- Performance optimizations for blazing fast Neovim
return {
  -- Faster startup with impatient (now built into Neovim 0.10+)
  {
    'lewis6991/impatient.nvim',
    enabled = false, -- Built into Neovim 0.10+
  },

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

  -- Garbage collection optimization
  {
    'zeioth/garbage-day.nvim',
    enabled = false, -- Disabled due to compatibility issue with Neovim 0.11.x
    event = 'VeryLazy',
    dependencies = 'neovim/nvim-lspconfig',
    opts = {
      aggressive_mode = false,
      excluded_lsp_clients = {},
      grace_period = 60 * 15, -- 15 minutes
      wakeup_delay = 3000,
      notifications = false,
    },
  },

  -- Smooth scrolling (performance-optimized)
  {
    'karb94/neoscroll.nvim',
    enabled = false, -- Using native smoothscroll in Neovim 0.10+
    event = 'WinScrolled',
    config = function()
      require('neoscroll').setup({
        mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
        hide_cursor = true,
        stop_eof = true,
        use_local_scrolloff = false,
        respect_scrolloff = false,
        cursor_scrolls_alone = true,
        easing_function = 'quadratic',
        pre_hook = nil,
        post_hook = nil,
        performance_mode = true,
      })
    end,
  },

  -- Filetype detection optimization
  {
    'nathom/filetype.nvim',
    enabled = false, -- Built into Neovim now
    lazy = false,
    config = function()
      require('filetype').setup({
        overrides = {
          extensions = {
            tf = 'terraform',
            tfvars = 'terraform',
            tfstate = 'json',
            mdx = 'markdown',
          },
          literal = {
            ['.eslintrc'] = 'json',
            ['.prettierrc'] = 'json',
            ['.babelrc'] = 'json',
            ['.stylelintrc'] = 'json',
          },
          complex = {
            ['.*%.env.*'] = 'sh',
            ['.*%.config%.js'] = 'javascript',
            ['.*%.config%.ts'] = 'typescript',
          },
        },
      })
    end,
  },

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
        enabled = true,
        timeout = 3000,
        width = { min = 40, max = 0.4 },
        height = { min = 1, max = 0.6 },
        top_down = false,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false }, -- We have our own
      words = { enabled = true },
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

  -- Faster syntax highlighting for large files
  {
    'nvim-treesitter/nvim-treesitter-context',
    enabled = false, -- Disabled to avoid duplicate context display with winbar
    event = 'BufRead',
    config = function()
      require('treesitter-context').setup({
        enable = true,
        max_lines = 3,
        min_window_height = 0,
        line_numbers = true,
        multiline_threshold = 20,
        trim_scope = 'outer',
        mode = 'cursor',
        separator = nil,
        zindex = 20,
        on_attach = nil,
      })
    end,
  },
}
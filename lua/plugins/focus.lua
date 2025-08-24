-- Focus mode and session management for deep work
return {
  -- Zen Mode for distraction-free coding
  {
    'folke/zen-mode.nvim',
    cmd = 'ZenMode',
    opts = {
      window = {
        backdrop = 0.95, -- Shade of the backdrop
        width = 120, -- Width of the Zen window
        height = 1, -- Height of the Zen window (1 = full height)
        options = {
          signcolumn = 'no', -- Disable signcolumn
          number = false, -- Disable number column
          relativenumber = false, -- Disable relative numbers
          cursorline = false, -- Disable cursor line
          cursorcolumn = false, -- Disable cursor column
          foldcolumn = '0', -- Disable fold column
          list = false, -- Disable whitespace characters
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false, -- Disables the ruler text in the cmd line area
          showcmd = false, -- Disables the command in the last line of the screen
          laststatus = 0, -- Turn off the statusline in zen mode
        },
        twilight = { enabled = true }, -- Enable Twilight when zen mode is enabled
        gitsigns = { enabled = false }, -- Disables git signs
        tmux = { enabled = false }, -- Disables the tmux statusline
        kitty = {
          enabled = true,
          font = '+4', -- Font size increment
        },
        alacritty = {
          enabled = true,
          font = '14', -- Font size
        },
        wezterm = {
          enabled = true,
          font = '+4', -- (10% increase per step)
        },
      },
      on_open = function(_)
        -- Store the current colorscheme settings
        vim.g.zen_mode_active = true
        -- Disable various UI elements
        vim.opt.winbar = ''
      end,
      on_close = function()
        -- Restore settings
        vim.g.zen_mode_active = false
      end,
    },
    keys = {
      { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Toggle Zen Mode' },
    },
  },

  -- Twilight: Dim inactive portions of code
  {
    'folke/twilight.nvim',
    cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    opts = {
      dimming = {
        alpha = 0.25, -- Amount of dimming
        color = { 'Normal', '#ffffff' },
        term_bg = '#000000',
        inactive = false, -- When true, other windows will be fully dimmed
      },
      context = 10, -- Amount of lines we will try to show around the current line
      treesitter = true,
      expand = { -- For treesitter, we always try to expand to the top-most ancestor
        'function',
        'method',
        'table',
        'if_statement',
      },
      exclude = {}, -- Exclude these filetypes
    },
  },

  -- Auto Session Management
  {
    'rmagatti/auto-session',
    lazy = false, -- Load immediately for session restoration
    opts = {
      log_level = 'error',
      auto_session_enabled = true,
      auto_session_create_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_suppress_dirs = { '~/', '~/Downloads', '~/Documents', '~/Desktop/', '/' },
      auto_session_use_git_branch = true,
      bypass_session_save_file_types = { 'alpha', 'dashboard' },
      
      -- Session lens configuration
      session_lens = {
        load_on_setup = true,
        theme_conf = { border = true },
        previewer = false,
        buftypes_to_ignore = {}, -- list of buffer types that should not be deleted from current session
      },
      
      -- Pre-save commands
      pre_save_cmds = {
        function()
          -- Close all floating windows
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local config = vim.api.nvim_win_get_config(win)
            if config.relative ~= '' then
              vim.api.nvim_win_close(win, false)
            end
          end
          -- Close nvim-tree, neo-tree, etc.
          vim.cmd('NvimTreeClose 2>/dev/null')
          vim.cmd('Neotree close 2>/dev/null')
        end,
      },
    },
    config = function(_, opts)
      require('auto-session').setup(opts)
      
      -- Session commands
      vim.keymap.set('n', '<leader>qs', '<cmd>Telescope session-lens search_session<cr>', { desc = 'Search sessions' })
      vim.keymap.set('n', '<leader>qS', '<cmd>SessionSave<cr>', { desc = 'Save session' })
      vim.keymap.set('n', '<leader>qr', '<cmd>SessionRestore<cr>', { desc = 'Restore session' })
      vim.keymap.set('n', '<leader>qd', '<cmd>SessionDelete<cr>', { desc = 'Delete session' })
    end,
  },

  -- Persistence (alternative session management)
  {
    'folke/persistence.nvim',
    enabled = false, -- Using auto-session instead
    event = 'BufReadPre',
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/'),
      options = { 'buffers', 'curdir', 'tabpages', 'winsize', 'help', 'globals', 'skiprtp' },
      pre_save = nil,
      save_empty = false,
    },
    keys = {
      { '<leader>qs', function() require('persistence').load() end, desc = 'Restore Session' },
      { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore Last Session' },
      { '<leader>qd', function() require('persistence').stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- Better window management
  {
    'sindrets/winshift.nvim',
    cmd = 'WinShift',
    config = true,
    keys = {
      { '<leader>ww', '<cmd>WinShift<cr>', desc = 'Win Shift' },
      { '<leader>ws', '<cmd>WinShift swap<cr>', desc = 'Win Swap' },
      { '<leader>wh', '<cmd>WinShift left<cr>', desc = 'Win Shift Left' },
      { '<leader>wj', '<cmd>WinShift down<cr>', desc = 'Win Shift Down' },
      { '<leader>wk', '<cmd>WinShift up<cr>', desc = 'Win Shift Up' },
      { '<leader>wl', '<cmd>WinShift right<cr>', desc = 'Win Shift Right' },
    },
  },

  -- Focus window auto-resizing
  {
    'nvim-focus/focus.nvim',
    enabled = false, -- Can be distracting, enable if desired
    version = false,
    config = function()
      require('focus').setup({
        enable = true,
        commands = true,
        autoresize = {
          enable = true,
          width = 120,
          height = 0,
          minwidth = 20,
          minheight = 0,
          height_quickfix = 10,
        },
        split = {
          bufnew = false,
          tmux = false,
        },
        ui = {
          number = false,
          relativenumber = false,
          hybridnumber = false,
          absolutenumber_unfocussed = false,
          cursorline = true,
          cursorcolumn = false,
          colorcolumn = {
            enable = false,
            list = '+1',
          },
          signcolumn = true,
          winhighlight = false,
        },
      })
    end,
  },

  -- Distraction-free mode toggle utilities
  {
    'pocco81/true-zen.nvim',
    enabled = false, -- Using zen-mode instead
    cmd = { 'TZAtaraxis', 'TZMinimalist', 'TZNarrow', 'TZFocus' },
    config = true,
  },
}
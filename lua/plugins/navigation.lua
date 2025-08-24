-- Navigation and movement plugins
return {
  -- Flash for lightning-fast navigation
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {
      labels = 'asdfghjklqwertyuiopzxcvbnm',
      search = {
        multi_window = true,
        forward = true,
        wrap = true,
        mode = 'fuzzy',
        incremental = true,
      },
      jump = {
        jumplist = true,
        pos = 'start',
        history = false,
        register = false,
        nohlsearch = false,
        autojump = false,
      },
      modes = {
        search = {
          enabled = true,
          highlight = { backdrop = false },
          jump = { history = true, register = true, nohlsearch = true },
        },
        char = {
          enabled = true,
          config = function(opts)
            opts.autohide = vim.fn.mode(true):find('no') and vim.v.operator == 'y'
            opts.jump_labels = opts.jump_labels and vim.v.count == 0
          end,
          highlight = { backdrop = true },
          jump = { register = false },
          multi_line = true,
        },
      },
    },
    keys = {
      {
        's',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'r',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'R',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },

  -- Harpoon for quick file switching
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        },
      })

      -- Keymaps
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon: Add file' })

      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: Toggle menu' })

      -- Quick navigation to harpooned files (using leader to avoid conflicts)
      vim.keymap.set('n', '<leader>1', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon: Go to file 1' })
      
      vim.keymap.set('n', '<leader>2', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon: Go to file 2' })
      
      vim.keymap.set('n', '<leader>3', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon: Go to file 3' })
      
      vim.keymap.set('n', '<leader>4', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon: Go to file 4' })

      -- Toggle previous & next buffers stored within Harpoon list
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: Previous buffer' })
      
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: Next buffer' })
    end,
  },

  -- Better diagnostics list
  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    opts = {
      use_diagnostic_signs = true,
    },
    keys = {
      { '<leader>xx', '<cmd>TroubleToggle document_diagnostics<cr>', desc = 'Document Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics (Trouble)' },
      { '<leader>xL', '<cmd>TroubleToggle loclist<cr>', desc = 'Location List (Trouble)' },
      { '<leader>xQ', '<cmd>TroubleToggle quickfix<cr>', desc = 'Quickfix List (Trouble)' },
      {
        '[q',
        function()
          if require('trouble').is_open() then
            require('trouble').previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Previous Trouble/Quickfix Item',
      },
      {
        ']q',
        function()
          if require('trouble').is_open() then
            require('trouble').next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = 'Next Trouble/Quickfix Item',
      },
    },
  },

  -- Improved motions
  {
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    opts = function()
      local ai = require('mini.ai')
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          }),
          f = ai.gen_spec.treesitter({ a = '@function.outer', i = '@function.inner' }), -- function
          c = ai.gen_spec.treesitter({ a = '@class.outer', i = '@class.inner' }), -- class
          t = { '<([%p%l]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^<>]*>' }, -- tags
          d = { '%f[%d]%d+' }, -- digits
          e = { -- Word with case
            { '%u[%l%d]+%f[^%l%d]', '%f[%S][%l%d]+%f[^%l%d]', '%f[%P][%l%d]+%f[^%l%d]', '^[%l%d]+%f[^%l%d]' },
            '^().*()$',
          },
          g = function() -- Whole buffer
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line('$'),
              col = math.max(vim.fn.getline('$'):len(), 1),
            }
            return { from = from, to = to }
          end,
        },
      }
    end,
  },

  -- Better surround operations
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = true,
  },

  -- Oil.nvim: Edit filesystem like a buffer (craftzdog style)
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = { 'icon' },
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = false,
        cleanup_delay_ms = 2000,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = 'actions.select_vsplit',
          ['<C-h>'] = 'actions.select_split',
          ['<C-t>'] = 'actions.select_tab',
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, _)
            return vim.startswith(name, '.')
          end,
          is_always_hidden = function(name, _)
            return name == '..' or name == '.git'
          end,
        },
        float = {
          padding = 2,
          max_width = 80,
          max_height = 40,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },
      })
      
      -- Keymaps
      vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
      vim.keymap.set('n', '<leader>-', function()
        require('oil').toggle_float()
      end, { desc = 'Open parent directory (float)' })
    end,
  },

  -- Smart splits (like tmux but better)
  {
    'mrjones2014/smart-splits.nvim',
    lazy = false,
    config = function()
      local smart_splits = require('smart-splits')
      smart_splits.setup({
        ignored_filetypes = { 'nofile', 'quickfix', 'prompt' },
        ignored_buftypes = { 'NvimTree' },
        default_amount = 3,
        move_cursor_same_row = false,
        resize_mode = {
          quit_key = '<ESC>',
          resize_keys = { 'h', 'j', 'k', 'l' },
          silent = false,
        },
      })
      
      -- Navigation
      vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { desc = 'Move to left split' })
      vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { desc = 'Move to below split' })
      vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { desc = 'Move to above split' })
      vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { desc = 'Move to right split' })
      
      -- Resizing
      vim.keymap.set('n', '<A-h>', smart_splits.resize_left, { desc = 'Resize split left' })
      vim.keymap.set('n', '<A-j>', smart_splits.resize_down, { desc = 'Resize split down' })
      vim.keymap.set('n', '<A-k>', smart_splits.resize_up, { desc = 'Resize split up' })
      vim.keymap.set('n', '<A-l>', smart_splits.resize_right, { desc = 'Resize split right' })
    end,
  },

  -- Project management
  {
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({
        manual_mode = false,
        detection_methods = { 'lsp', 'pattern' },
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json' },
        ignore_lsp = {},
        exclude_dirs = {},
        show_hidden = false,
        silent_chdir = true,
        scope_chdir = 'global',
        datapath = vim.fn.stdpath('data'),
      })
      
      -- Integrate with Telescope
      require('telescope').load_extension('projects')
      
      vim.keymap.set('n', '<leader>fp', '<cmd>Telescope projects<cr>', { desc = 'Find projects' })
    end,
  },
}
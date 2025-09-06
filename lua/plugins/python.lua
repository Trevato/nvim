-- Modern Python development tools (2025)
return {
  -- iron.nvim for REPL interaction
  {
    'Vigemus/iron.nvim',
    ft = { 'python' },
    config = function()
      local iron = require('iron.core')
      
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { 'ipython', '--no-autoindent' },
              format = require('iron.fts.common').bracketed_paste_python,
            },
          },
          repl_open_cmd = require('iron.view').split.vertical.botright(0.4),
        },
        keymaps = {
          send_motion = '++',
          visual_send = '++',
          send_file = '+f',
          send_line = '++',
          send_until_cursor = '+u',
          send_mark = '+m',
          mark_motion = '+mc',
          mark_visual = '+mc',
          remove_mark = '+md',
          cr = '+<cr>',
          interrupt = '+<space>',
          exit = '+q',
          clear = '+c',
        },
        highlight = {
          italic = false,
        },
        ignore_blank_lines = true,
      })
    end,
    keys = {
      { '++', mode = { 'n', 'x' }, desc = 'Send to REPL' },
      { '+r', '<cmd>IronRepl<cr>', desc = 'Open REPL' },
      { '+R', '<cmd>IronRestart<cr>', desc = 'Restart REPL' },
      { '+f', '<cmd>IronFocus<cr>', desc = 'Focus REPL' },
      { '+h', '<cmd>IronHide<cr>', desc = 'Hide REPL' },
    },
  },
  
  -- neotest for testing
  {
    'nvim-neotest/neotest',
    ft = { 'python' },
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      -- Python adapter
      'nvim-neotest/neotest-python',
    },
    config = function()
      require('neotest').setup({
        adapters = {
          require('neotest-python')({
            dap = { justMyCode = false },
            runner = 'pytest',
            python = '.venv/bin/python',
            pytest_discover_instances = true,
          }),
        },
        quickfix = {
          enabled = true,
          open = false,
        },
        output = {
          enabled = true,
          open_on_run = false,
        },
        status = {
          enabled = true,
          virtual_text = true,
          signs = true,
        },
        icons = {
          expanded = '',
          child_prefix = '├',
          child_indent = '│',
          final_child_prefix = '└',
          non_collapsible = '─',
          passed = '✓',
          running = '◴',
          failed = '✗',
          unknown = '?',
          skipped = '○',
        },
      })
    end,
    keys = {
      { '<leader>tn', function() require('neotest').run.run() end, desc = 'Test nearest' },
      { '<leader>tf', function() require('neotest').run.run(vim.fn.expand('%')) end, desc = 'Test file' },
      { '<leader>td', function() require('neotest').run.run({ strategy = 'dap' }) end, desc = 'Debug test' },
      { '<leader>ts', function() require('neotest').run.stop() end, desc = 'Stop test' },
      { '<leader>ta', function() require('neotest').run.attach() end, desc = 'Attach to test' },
      { '<leader>to', function() require('neotest').output.open({ enter = true, auto_close = true }) end, desc = 'Test output' },
      { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Toggle test output panel' },
      { '<leader>tw', function() require('neotest').watch.toggle() end, desc = 'Watch test' },
      { '<leader>tS', function() require('neotest').summary.toggle() end, desc = 'Toggle test summary' },
      { '[t', function() require('neotest').jump.prev({ status = 'failed' }) end, desc = 'Previous failed test' },
      { ']t', function() require('neotest').jump.next({ status = 'failed' }) end, desc = 'Next failed test' },
    },
  },
  
  -- Virtual environment selector
  {
    'linux-cultist/venv-selector.nvim',
    branch = 'regexp',
    ft = { 'python' },
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-telescope/telescope.nvim',
      'mfussenegger/nvim-dap',
    },
    opts = {
      name = {
        'venv',
        '.venv',
        'env',
        '.env',
      },
      auto_refresh = true,
      search_venv_managers = true,
      search_workspace = true,
      search = true,
      dap_enabled = true,
      notify_user_on_venv_activation = true,
      -- uv, poetry, pipenv, pyenv, conda, etc.
      venv_manager_preference = {
        'uv',
        'poetry',
        'pipenv',
        'pyenv',
        'conda',
      },
      parents = 2,
      anaconda_base_path = vim.fn.expand('~/miniconda3'),
      anaconda_envs_path = vim.fn.expand('~/miniconda3/envs'),
    },
    keys = {
      { '<leader>vs', '<cmd>VenvSelect<cr>', desc = 'Select virtualenv' },
      { '<leader>vc', '<cmd>VenvSelectCached<cr>', desc = 'Select cached virtualenv' },
      { '<leader>vl', '<cmd>VenvSelectLog<cr>', desc = 'Show venv log' },
    },
  },
  
  -- Docstring generation
  {
    'danymat/neogen',
    ft = { 'python' },
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('neogen').setup({
        enabled = true,
        snippet_engine = 'luasnip',
        languages = {
          python = {
            template = {
              annotation_convention = 'numpydoc', -- google, numpydoc, or reST
            },
          },
        },
      })
    end,
    keys = {
      {
        '<leader>ds',
        function()
          require('neogen').generate({ type = 'func' })
        end,
        desc = 'Generate docstring',
      },
      {
        '<leader>dc',
        function()
          require('neogen').generate({ type = 'class' })
        end,
        desc = 'Generate class docstring',
      },
      {
        '<leader>df',
        function()
          require('neogen').generate({ type = 'file' })
        end,
        desc = 'Generate file docstring',
      },
      {
        '<leader>dt',
        function()
          require('neogen').generate({ type = 'type' })
        end,
        desc = 'Generate type docstring',
      },
    },
  },
  
  -- Mason tools installation
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, {
        'basedpyright',
        'ruff',
        'debugpy',
      })
      return opts
    end,
  },
}
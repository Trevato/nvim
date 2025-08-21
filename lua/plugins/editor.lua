-- Editor enhancement plugins
return {
  -- Treesitter for syntax highlighting and code understanding
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'javascript',
        'typescript',
        'tsx',
        'python',
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },
  
  -- Telescope - fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      })

      -- Enable extensions
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- Keymaps
      local builtin = require('telescope.builtin')
      
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = '[/] Fuzzily search in current buffer' })
      
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        })
      end, { desc = '[S]earch [/] in Open Files' })
      
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files({ cwd = vim.fn.stdpath('config') })
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  
  -- Mini modules for editor enhancements
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      require('mini.ai').setup({ n_lines = 500 })

      -- Add/delete/replace surroundings
      require('mini.surround').setup()
    end,
  },
  
  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
      },
      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
        offset = 0,
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'PmenuSel',
        highlight_grey = 'LineNr',
      },
    },
  },
  
  -- Indent lines
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        tab_char = '│',
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          'help',
          'alpha',
          'dashboard',
          'neo-tree',
          'Trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
      },
    },
  },
  
  -- Linting
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require('lint')

      -- Dynamically choose linter based on project config
      local function get_js_linter()
        local root = vim.fn.getcwd()
        if vim.fn.filereadable(root .. '/biome.json') == 1 then
          return { 'biomejs' }
        elseif vim.fn.filereadable(root .. '/.eslintrc.js') == 1
          or vim.fn.filereadable(root .. '/.eslintrc.json') == 1
          or vim.fn.filereadable(root .. '/eslint.config.js') == 1
          or vim.fn.filereadable(root .. '/eslint.config.mjs') == 1 then
          return { 'eslint_d' }
        else
          -- Default to biomejs for new projects
          return { 'biomejs' }
        end
      end

      -- Set linters dynamically
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufNewFile' }, {
        pattern = { '*.js', '*.jsx', '*.ts', '*.tsx', '*.mjs', '*.cjs' },
        callback = function()
          local linter = get_js_linter()
          lint.linters_by_ft.javascript = linter
          lint.linters_by_ft.typescript = linter
          lint.linters_by_ft.javascriptreact = linter
          lint.linters_by_ft.typescriptreact = linter
        end,
      })

      lint.linters_by_ft = {
        python = { 'ruff' },
      }

      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })

      vim.keymap.set('n', '<leader>l', function()
        lint.try_lint()
      end, { desc = 'Trigger linting for current file' })
    end,
  },
  
  -- Formatting
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    config = function()
      -- Global variable to control auto-formatting
      vim.g.autoformat_enabled = false -- Start with auto-format disabled
      
      -- Dynamically choose formatter based on project config
      local function get_js_formatter()
        local root = vim.fn.getcwd()
        if vim.fn.filereadable(root .. '/biome.json') == 1 then
          return { 'biome' }
        elseif vim.fn.filereadable(root .. '/.prettierrc') == 1
          or vim.fn.filereadable(root .. '/.prettierrc.js') == 1
          or vim.fn.filereadable(root .. '/.prettierrc.json') == 1
          or vim.fn.filereadable(root .. '/prettier.config.js') == 1 then
          return { 'prettier' }
        else
          -- Default to biome for new projects
          return { 'biome' }
        end
      end

      require('conform').setup({
        notify_on_error = false,
        format_on_save = function(bufnr)
          -- Check if auto-formatting is enabled
          if not vim.g.autoformat_enabled then
            return nil
          end
          
          local disable_filetypes = { c = true, cpp = true }
          local lsp_format_opt
          if disable_filetypes[vim.bo[bufnr].filetype] then
            lsp_format_opt = 'never'
          else
            lsp_format_opt = 'fallback'
          end
          return {
            timeout_ms = 500,
            lsp_format = lsp_format_opt,
          }
        end,
        formatters_by_ft = {
          lua = { 'stylua' },
          javascript = get_js_formatter,
          typescript = get_js_formatter,
          javascriptreact = get_js_formatter,
          typescriptreact = get_js_formatter,
          ['typescript.tsx'] = get_js_formatter,
          ['javascript.jsx'] = get_js_formatter,
          css = get_js_formatter,
          html = { 'prettier' },
          json = get_js_formatter,
          yaml = { 'prettier' },
          markdown = { 'prettier' },
          python = { 'isort', 'ruff' },
        },
      })
      
      -- Keymaps for formatting
      vim.keymap.set('n', '<leader>f', function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end, { desc = '[F]ormat buffer' })
      
      -- Toggle auto-formatting
      vim.keymap.set('n', '<leader>tf', function()
        vim.g.autoformat_enabled = not vim.g.autoformat_enabled
        if vim.g.autoformat_enabled then
          vim.notify('Auto-format enabled', vim.log.levels.INFO)
        else
          vim.notify('Auto-format disabled', vim.log.levels.INFO)
        end
      end, { desc = '[T]oggle auto-[F]ormat on save' })
      
      -- Show current auto-format status
      vim.keymap.set('n', '<leader>?f', function()
        if vim.g.autoformat_enabled then
          vim.notify('Auto-format is currently ENABLED', vim.log.levels.INFO)
        else
          vim.notify('Auto-format is currently DISABLED', vim.log.levels.INFO)
        end
      end, { desc = 'Show auto-format status' })
    end,
  },
}

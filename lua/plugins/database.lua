-- Database tools for SQL development
return {
  -- vim-dadbod: Database interface
  {
    'tpope/vim-dadbod',
    lazy = true,
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    dependencies = {
      -- UI for vim-dadbod
      {
        'kristijanhusak/vim-dadbod-ui',
        dependencies = {
          { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql', 'psql', 'pgsql' } },
        },
        cmd = {
          'DBUI',
          'DBUIToggle',
          'DBUIAddConnection',
          'DBUIFindBuffer',
        },
        init = function()
          -- Your DBUI configuration
          vim.g.db_ui_use_nerd_fonts = 1
          vim.g.db_ui_show_database_icon = 1
          vim.g.db_ui_force_echo_notifications = 1
          vim.g.db_ui_win_position = 'left'
          vim.g.db_ui_winwidth = 40

          -- Icons for DBUI
          vim.g.db_ui_icons = {
            expanded = {
              db = '▾ ',
              buffers = '▾ ',
              saved_queries = '▾ ',
              schemas = '▾ ',
              schema = '▾ ',
              tables = '▾ ',
              table = '▾ ',
            },
            collapsed = {
              db = '▸ ',
              buffers = '▸ ',
              saved_queries = '▸ ',
              schemas = '▸ ',
              schema = '▸ ',
              tables = '▸ ',
              table = '▸ ',
            },
            saved_query = ' ',
            new_query = ' ',
            tables = ' ',
            buffers = ' ',
            add_connection = ' ',
            connection_ok = '✓',
            connection_error = '✕',
          }
        end,
      },
    },
    keys = {
      { '<leader>db', '<cmd>DBUIToggle<cr>', desc = 'Toggle DB UI' },
      { '<leader>df', '<cmd>DBUIFindBuffer<cr>', desc = 'Find DB buffer' },
      { '<leader>dr', '<cmd>DBUIRenameBuffer<cr>', desc = 'Rename DB buffer' },
      { '<leader>dl', '<cmd>DBUILastQueryInfo<cr>', desc = 'Last query info' },
    },
  },

  -- SQL completion from database schema
  {
    'kristijanhusak/vim-dadbod-completion',
    dependencies = 'tpope/vim-dadbod',
    ft = { 'sql', 'mysql', 'plsql', 'psql', 'pgsql' },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql', 'psql', 'pgsql' },
        callback = function()
          -- Enable dadbod completion for SQL files
          local cmp = require('blink.cmp')
          vim.b.minicompletion_disable = true
        end,
      })
    end,
  },

  -- Better SQL syntax highlighting
  {
    'tpope/vim-dotenv',
    lazy = true,
    cmd = { 'Dotenv', 'DotenvEdit' },
  },
}
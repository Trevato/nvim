-- AI and code assistance plugins
return {
  -- Supermaven for ultra-fast AI autocomplete (10x faster than Copilot)
  {
    'supermaven-inc/supermaven-nvim',
    event = 'InsertEnter',
    config = function()
      local ok, supermaven = pcall(require, 'supermaven-nvim')
      if not ok then
        vim.notify('Supermaven not loaded', vim.log.levels.WARN)
        return
      end
      
      supermaven.setup({
        keymaps = {
          accept_suggestion = '<C-j>', -- Changed from Tab to avoid conflicts
          clear_suggestion = '<C-]>',
          accept_word = '<C-Right>',
        },
        ignore_filetypes = { 
          cpp = true,
          c = true,
        },
        color = {
          suggestion_color = '#808080',
          cterm = 244,
        },
        log_level = 'warn', -- Changed to warn to reduce noise
        disable_inline_completion = false,
        disable_keymaps = false,
      })
    end,
  },

  -- GitHub Copilot as fallback
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        panel = {
          enabled = false,
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = false, -- We'll use Supermaven's Tab
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = false,
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node',
        server_opts_overrides = {},
      })
    end,
  },

  -- Copilot Chat for AI conversations
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    branch = 'canary',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    opts = {
      debug = false,
      window = {
        layout = 'vertical',
        width = 0.3,
      },
    },
    keys = {
      {
        '<leader>cc',
        function()
          require('CopilotChat').toggle()
        end,
        desc = 'Toggle Copilot Chat',
      },
      {
        '<leader>cq',
        function()
          local input = vim.fn.input('Quick Chat: ')
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'Quick chat with Copilot',
      },
      {
        '<leader>ch',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.telescope').pick(actions.help_actions())
        end,
        desc = 'Copilot Help actions',
      },
      {
        '<leader>cp',
        function()
          local actions = require('CopilotChat.actions')
          require('CopilotChat.integrations.telescope').pick(actions.prompt_actions())
        end,
        desc = 'Copilot Prompt actions',
      },
    },
  },
}
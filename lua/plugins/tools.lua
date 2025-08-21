-- External tools integration
return {
  -- LazyDocker: Terminal UI for Docker
  {
    'mgierada/lazydocker.nvim',
    dependencies = { 'akinsho/toggleterm.nvim' },
    config = function()
      require('lazydocker').setup({
        border = 'curved',
      })
    end,
    event = 'BufRead',
    keys = {
      {
        '<leader>ld',
        function()
          require('lazydocker').open()
        end,
        desc = 'Open Lazydocker floating window',
      },
    },
  },
  
  -- Debug Adapter Protocol
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Required by nvim-dap-ui
      'nvim-neotest/nvim-nio',
      
      -- Fancy UI for the debugger
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 
          'MunifTanjim/nui.nvim', -- Fixed repository URL
          'nvim-neotest/nvim-nio',
        },
        opts = {},
      },

      -- Virtual text for the debugger
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },

      -- Mason integration
      {
        'jay-babu/mason-nvim-dap.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        cmd = { 'DapInstall', 'DapUninstall' },
        opts = {
          -- Makes a best effort to setup the various debuggers with
          -- reasonable debug configurations
          automatic_installation = true,

          -- You can provide additional configuration to the handlers,
          -- see mason-nvim-dap README for more information
          handlers = {},

          -- You'll need to check that you have the required things installed
          -- online, please don't ask me how to install them :)
          ensure_installed = {
            -- Update this to ensure that you have the debuggers for the langs you want
            'python',
            'js',
          },
        },
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Set up the UI
      dapui.setup()

      -- Auto open/close UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Set up keymaps
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Debug: Toggle [B]reakpoint' })
      vim.keymap.set('n', '<leader>dB', function()
        dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
      end, { desc = 'Debug: Set [B]reakpoint with condition' })
      
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = 'Debug: [C]ontinue' })
      vim.keymap.set('n', '<leader>dC', dap.run_to_cursor, { desc = 'Debug: Run to [C]ursor' })
      
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step [I]nto' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step [O]ver' })
      vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Debug: Step [O]ut' })
      
      vim.keymap.set('n', '<leader>dl', dap.run_last, { desc = 'Debug: Run [L]ast' })
      vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug: Open [R]EPL' })
      
      vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Debug: [T]oggle UI' })
    end,
  },
}

-- Enhanced terminal integration for live command output
return {
  -- Better terminal integration with toggleterm
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return vim.o.lines * 0.3
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = 0,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = 'horizontal',
        close_on_exit = false,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = 'rounded',
          winblend = 0,
        },
        winbar = {
          enabled = true,
          name_formatter = function(term)
            return string.format(' Terminal %s ', term.id)
          end,
        },
      })

      -- Custom function to run shell commands with live output
      local Terminal = require('toggleterm.terminal').Terminal

      -- Create a function to run commands with live output
      _G.run_with_live_output = function(cmd)
        if not cmd or cmd == '' then
          cmd = vim.fn.input('Shell command: ')
        end

        local term = Terminal:new({
          cmd = cmd,
          direction = 'horizontal',
          close_on_exit = false,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
            vim.api.nvim_buf_set_keymap(term.bufnr, 'n', '<Esc>', '<cmd>close<CR>', { noremap = true, silent = true })
          end,
        })
        term:toggle()
      end

      -- Override the default :! behavior to use our live terminal
      vim.api.nvim_create_user_command('Shell', function(opts)
        run_with_live_output(opts.args)
      end, { nargs = '*' })

      -- Keymaps for terminal
      vim.keymap.set('n', '<leader>tr', ':Shell ', { desc = 'Run command with live output' })
      vim.keymap.set('n', '<leader>tl', '<cmd>ToggleTermSendCurrentLine<CR>', { desc = 'Send line to terminal' })
      vim.keymap.set('v', '<leader>ts', '<cmd>ToggleTermSendVisualSelection<CR>', { desc = 'Send selection to terminal' })
    end,
  },
}
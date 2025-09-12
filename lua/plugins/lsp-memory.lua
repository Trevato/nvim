-- Custom LSP memory management for Neovim 0.11+
-- Replaces garbage-day.nvim with a lightweight solution
return {
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      -- Track buffer activity
      local buffer_timers = {}
      local inactive_timeout = 15 * 60 * 1000 -- 15 minutes in milliseconds

      -- Stop LSP clients for inactive buffers
      local function stop_inactive_lsp(bufnr)
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        for _, client in ipairs(clients) do
          -- Don't stop essential clients
          if client.name ~= 'copilot' and client.name ~= 'null-ls' then
            vim.lsp.stop_client(client.id, false)
          end
        end
        -- Run garbage collection after stopping clients
        collectgarbage('collect')
      end

      -- Reset timer for buffer activity
      local function reset_buffer_timer(bufnr)
        if buffer_timers[bufnr] then
          vim.fn.timer_stop(buffer_timers[bufnr])
        end
        
        buffer_timers[bufnr] = vim.fn.timer_start(inactive_timeout, function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            stop_inactive_lsp(bufnr)
          end
          buffer_timers[bufnr] = nil
        end)
      end

      -- Set up autocmds for buffer activity tracking
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWrite', 'InsertEnter', 'CursorMoved' }, {
        group = vim.api.nvim_create_augroup('LspMemoryManagement', { clear = true }),
        callback = function(args)
          reset_buffer_timer(args.buf)
        end,
      })

      -- Clean up timers when buffer is deleted
      vim.api.nvim_create_autocmd('BufDelete', {
        group = vim.api.nvim_create_augroup('LspMemoryCleanup', { clear = true }),
        callback = function(args)
          if buffer_timers[args.buf] then
            vim.fn.timer_stop(buffer_timers[args.buf])
            buffer_timers[args.buf] = nil
          end
        end,
      })

      -- Manual garbage collection on buffer switch
      vim.api.nvim_create_autocmd('BufLeave', {
        group = vim.api.nvim_create_augroup('LspGarbageCollect', { clear = true }),
        callback = function()
          -- Only run GC occasionally to avoid performance impact
          if math.random() < 0.1 then -- 10% chance
            vim.defer_fn(function()
              collectgarbage('collect')
            end, 100)
          end
        end,
      })

      -- Add command to manually clean up LSP memory
      vim.api.nvim_create_user_command('LspCleanup', function()
        local before = collectgarbage('count')
        
        -- Stop all LSP clients except essential ones
        local clients = vim.lsp.get_clients()
        local active_buffers = vim.tbl_filter(function(buf)
          return vim.api.nvim_buf_is_valid(buf) and 
                 vim.api.nvim_get_option_value('buflisted', { buf = buf })
        end, vim.api.nvim_list_bufs())
        
        for _, client in ipairs(clients) do
          local has_active_buffer = false
          for _, buf in ipairs(active_buffers) do
            if vim.lsp.buf_is_attached(buf, client.id) then
              has_active_buffer = true
              break
            end
          end
          
          if not has_active_buffer and client.name ~= 'copilot' then
            vim.lsp.stop_client(client.id, false)
          end
        end
        
        collectgarbage('collect')
        local after = collectgarbage('count')
        
        vim.notify(
          string.format('LSP cleanup: %.2f MB freed', (before - after) / 1024),
          vim.log.levels.INFO,
          { title = 'LSP Memory' }
        )
      end, { desc = 'Clean up inactive LSP clients and run garbage collection' })

      -- Add status command to check memory usage
      vim.api.nvim_create_user_command('LspMemory', function()
        local clients = vim.lsp.get_clients()
        local memory = collectgarbage('count') / 1024
        
        vim.notify(
          string.format(
            'Active LSP clients: %d\nMemory usage: %.2f MB',
            #clients,
            memory
          ),
          vim.log.levels.INFO,
          { title = 'LSP Memory Status' }
        )
      end, { desc = 'Show LSP client count and memory usage' })

      return opts
    end,
  },
}
-- Performance monitoring and profiling tools
return {
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  -- Custom performance monitoring
  {
    'nvim-lua/plenary.nvim',
    config = function()
      -- Performance monitoring state
      local perf = {
        startup_time = nil,
        memory_usage = {},
        lsp_clients = {},
      }

      -- Measure startup time
      local start_time = vim.fn.reltime()
      vim.api.nvim_create_autocmd('VimEnter', {
        once = true,
        callback = function()
          perf.startup_time = vim.fn.reltimefloat(vim.fn.reltime(start_time)) * 1000
          
          -- Alert if startup exceeds target
          if perf.startup_time > 50 then
            vim.notify(
              string.format('⚠️  Startup time: %.1fms (target: <50ms)', perf.startup_time),
              vim.log.levels.WARN,
              { title = 'Performance Alert' }
            )
          end
        end,
      })

      -- Memory monitoring
      local function get_memory_usage()
        local memory_kb = collectgarbage('count')
        return memory_kb / 1024 -- Convert to MB
      end

      -- Track memory usage over time
      local memory_timer = vim.loop.new_timer()
      memory_timer:start(
        5000, -- 5 second delay
        30000, -- Check every 30 seconds
        vim.schedule_wrap(function()
          local memory_mb = get_memory_usage()
          table.insert(perf.memory_usage, {
            time = os.time(),
            memory = memory_mb,
          })
          
          -- Keep only last 100 measurements
          if #perf.memory_usage > 100 then
            table.remove(perf.memory_usage, 1)
          end
          
          -- Alert on high memory usage
          if memory_mb > 500 then
            vim.notify(
              string.format('High memory usage: %.1f MB', memory_mb),
              vim.log.levels.WARN,
              { title = 'Memory Alert' }
            )
          end
        end)
      )

      -- Performance report command
      vim.api.nvim_create_user_command('PerfReport', function()
        local report = {}
        
        -- Startup time
        if perf.startup_time then
          table.insert(report, string.format('Startup time: %.1fms', perf.startup_time))
        end
        
        -- Current memory
        local current_memory = get_memory_usage()
        table.insert(report, string.format('Current memory: %.1f MB', current_memory))
        
        -- LSP clients
        local clients = vim.lsp.get_clients()
        table.insert(report, string.format('Active LSP clients: %d', #clients))
        
        -- Loaded plugins
        local lazy_stats = require('lazy').stats()
        table.insert(report, string.format('Loaded plugins: %d/%d', lazy_stats.loaded, lazy_stats.count))
        
        -- Buffer count
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })
        table.insert(report, string.format('Open buffers: %d', #buffers))
        
        -- Display report
        vim.notify(table.concat(report, '\n'), vim.log.levels.INFO, { title = 'Performance Report' })
      end, { desc = 'Show performance metrics report' })

      -- Quick performance check statusline component
      _G.get_perf_status = function()
        local memory_mb = get_memory_usage()
        local clients = #vim.lsp.get_clients()
        
        local status = string.format('%.0fMB', memory_mb)
        if clients > 0 then
          status = status .. string.format(' LSP:%d', clients)
        end
        
        -- Color coding based on memory usage
        if memory_mb > 300 then
          return '%#DiagnosticError#' .. status .. '%*'
        elseif memory_mb > 200 then
          return '%#DiagnosticWarn#' .. status .. '%*'
        else
          return '%#DiagnosticHint#' .. status .. '%*'
        end
      end

      -- Startup profiling helper
      vim.api.nvim_create_user_command('StartupProfile', function()
        -- Run multiple startup time measurements
        vim.cmd('StartupTime')
      end, { desc = 'Profile startup time with multiple samples' })

      -- Memory cleanup command
      vim.api.nvim_create_user_command('MemoryClean', function()
        local before = get_memory_usage()
        
        -- Force garbage collection
        collectgarbage('collect')
        collectgarbage('collect') -- Run twice for thorough cleanup
        
        -- Clear unused buffers
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) and not vim.api.nvim_get_option_value('modified', { buf = buf }) then
            local win_count = #vim.fn.win_findbuf(buf)
            if win_count == 0 then
              vim.api.nvim_buf_delete(buf, { force = false })
            end
          end
        end
        
        local after = get_memory_usage()
        vim.notify(
          string.format('Memory cleaned: %.1f MB → %.1f MB (freed: %.1f MB)', 
            before, after, before - after),
          vim.log.levels.INFO,
          { title = 'Memory Cleanup' }
        )
      end, { desc = 'Clean up memory and unused buffers' })

      -- Auto cleanup on idle
      local idle_timer = vim.loop.new_timer()
      idle_timer:start(
        60000, -- 1 minute delay
        300000, -- Every 5 minutes
        vim.schedule_wrap(function()
          -- Only cleanup if memory usage is high
          if get_memory_usage() > 400 then
            vim.cmd('MemoryClean')
          end
        end)
      )

      -- Performance debugging helpers
      vim.api.nvim_create_user_command('DebugPerf', function()
        -- Show detailed performance info
        local info = {
          '=== Performance Debug Info ===',
          '',
          string.format('Neovim version: %s', vim.version().major .. '.' .. vim.version().minor .. '.' .. vim.version().patch),
          string.format('Startup time: %.1fms', perf.startup_time or 0),
          string.format('Memory usage: %.1f MB', get_memory_usage()),
          string.format('Garbage collection count: %d', collectgarbage('count')),
          '',
          '=== Plugin Load Times ===',
        }
        
        -- Get plugin load times from lazy
        local lazy_stats = require('lazy').stats()
        for _, plugin in ipairs(lazy_stats.times) do
          if plugin.time > 1 then -- Only show plugins taking >1ms
            table.insert(info, string.format('  %s: %.1fms', plugin.name, plugin.time))
          end
        end
        
        -- Create a scratch buffer with the info
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, info)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
        vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
        
        -- Open in a split
        vim.cmd('split')
        vim.api.nvim_win_set_buf(0, buf)
      end, { desc = 'Show detailed performance debugging information' })
    end,
  },
}
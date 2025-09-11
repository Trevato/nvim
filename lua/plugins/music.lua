-- Music and live coding plugins
-- Only load when NVIM_MUSIC environment variable is set
-- Usage: NVIM_MUSIC=1 nvim or use alias: nvim-music

if not vim.env.NVIM_MUSIC then
  return {}
end

vim.notify('Music mode enabled - Strudel plugin loading', vim.log.levels.INFO)

return {
  -- Strudel: Live coding music environment
  {
    'gruvw/strudel.nvim',
    build = 'npm install',
    lazy = false, -- Required for .str filetype detection
    config = function()
      require('strudel').setup({
        -- Performance optimizations
        headless = true, -- Reduce GPU/display overhead
        sync_cursor = false, -- Less synchronization overhead
        update_on_save = true, -- Auto-update when saving
        report_eval_errors = true, -- Show errors in Neovim
        
        -- Browser configuration
        browser_data_dir = vim.fn.expand('~/.cache/strudel-nvim/'),
        browser_exec_path = nil, -- Use system Chromium
        
        -- UI customization (hide redundant elements)
        ui = {
          hide_code_editor = true, -- We're using Neovim
          hide_menu_panel = false, -- Keep controls visible
          maximise_menu_panel = false, -- Normal size
          hide_top_bar = false, -- Keep navigation
          hide_error_display = false, -- Show errors in browser too
        },
        
        -- Custom CSS for better integration
        custom_css_file = nil, -- Add custom styling if needed
      })
      
      -- Set up keymaps for Strudel control
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { desc = 'Strudel: ' .. desc })
      end
      
      -- Music mode keymaps under <leader>m
      map('n', '<leader>ms', '<cmd>StrudelLaunch<cr>', 'Start session')
      map('n', '<leader>mt', '<cmd>StrudelToggle<cr>', 'Toggle playback')
      map('n', '<leader>mu', '<cmd>StrudelUpdate<cr>', 'Update/evaluate code')
      map('n', '<leader>mq', '<cmd>StrudelQuit<cr>', 'Quit session')
      map('n', '<leader>mx', '<cmd>StrudelStop<cr>', 'Stop playback')
      map('n', '<leader>me', '<cmd>StrudelExecute<cr>', 'Execute buffer')
      
      -- Optional: Hydra visuals toggle
      map('n', '<leader>mh', function()
        -- Toggle Hydra visuals via JavaScript evaluation
        vim.cmd([[StrudelExecute]])
        vim.notify('Executed current buffer in Strudel', vim.log.levels.INFO)
      end, 'Execute and show visuals')
      
      -- Auto-commands for .str files
      local strudel_group = vim.api.nvim_create_augroup('StrudelMusic', { clear = true })
      
      -- Auto-launch Strudel when opening .str files
      vim.api.nvim_create_autocmd('BufReadPost', {
        group = strudel_group,
        pattern = '*.str',
        callback = function()
          vim.notify('Strudel file detected. Use <leader>ms to launch browser sync', vim.log.levels.INFO)
          -- Don't auto-launch to avoid unexpected browser windows
          -- User can launch with <leader>ms when ready
        end,
      })
      
      -- Auto-update on save (already configured but adding visual feedback)
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = strudel_group,
        pattern = '*.str',
        callback = function()
          if vim.g.strudel_launched then
            vim.notify('Strudel pattern updated', vim.log.levels.INFO)
          end
        end,
      })
    end,
  },
}
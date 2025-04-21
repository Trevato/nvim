-- Git integration plugins
return {
  -- Gitsigns: Git decorations
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            return ']h'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to next hunk' })

        map('n', '[h', function()
          if vim.wo.diff then
            return '[h'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, desc = 'Jump to previous hunk' })

        -- Actions
        map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('v', '<leader>hs', function()
          gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'Stage selected hunk')
        map('v', '<leader>hr', function()
          gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end, 'Reset selected hunk')
        map('n', '<leader>hS', gs.stage_buffer, 'Stage buffer')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hR', gs.reset_buffer, 'Reset buffer')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
        map('n', '<leader>hb', function()
          gs.blame_line({ full = true })
        end, 'Blame line')
        map('n', '<leader>tb', gs.toggle_current_line_blame, 'Toggle blame')
        map('n', '<leader>hd', gs.diffthis, 'Diff against index')
        map('n', '<leader>hD', function()
          gs.diffthis('~')
        end, 'Diff against last commit')
        map('n', '<leader>td', gs.toggle_deleted, 'Toggle deleted')

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', 'Select hunk')
      end,
    },
  },
  
  -- LazyGit: Terminal UI for Git
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  
  -- Diffview: Enhanced diff and merge tools
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    config = function()
      require('diffview').setup({})
      
      -- Keymaps
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Open Diffview' })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'Current file history' })
      vim.keymap.set('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Repository history' })
    end,
  },
}

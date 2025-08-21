-- UI-related plugins
return {
  -- Dashboard
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')

      dashboard.section.header.val = {
        [[                                                                              ]],
        [[                      ████████╗██╗███╗   ███╗███████╗                        ]],
        [[                      ╚══██╔══╝██║████╗ ████║██╔════╝                        ]],
        [[                         ██║   ██║██╔████╔██║█████╗                          ]],
        [[                         ██║   ██║██║╚██╔╝██║██╔══╝                          ]],
        [[                         ██║   ██║██║ ╚═╝ ██║███████╗                        ]],
        [[                         ╚═╝   ╚═╝╚═╝     ╚═╝╚══════╝                        ]],
        [[                                                                              ]],
        [[          ████████╗ ██████╗      ██████╗ ██████╗  ██████╗ ██╗  ██╗ ]],
        [[          ╚══██╔══╝██╔═══██╗    ██╔════╝██╔═══██╗██╔═══██╗██║ ██╔╝ ]],
        [[             ██║   ██║   ██║    ██║     ██║   ██║██║   ██║█████╔╝  ]],
        [[             ██║   ██║   ██║    ██║     ██║   ██║██║   ██║██╔═██╗  ]],
        [[             ██║   ╚██████╔╝    ╚██████╗╚██████╔╝╚██████╔╝██║  ██╗ ]],
        [[             ╚═╝    ╚═════╝      ╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ]],
        [[                                                                              ]],
      }

      -- Personal links
      local function get_links()
        return ' trevato.dev · codewear.dev · github.com/trevato'
      end

      -- Git info with latest commit
      local function get_git_info()
        local branch_handle = io.popen('git branch --show-current 2>/dev/null')
        if not branch_handle then
          return ''
        end
        local branch = branch_handle:read('*l')
        branch_handle:close()

        if branch and branch ~= '' then
          local commit_handle = io.popen('git log -1 --pretty=format:"%h %s" 2>/dev/null')
          if not commit_handle then
            return ' ' .. branch
          end
          local commit = commit_handle:read('*l')
          commit_handle:close()

          if commit and commit ~= '' then
            return string.format(' %s · %s', branch:gsub('%s+', ''), commit)
          end
          return ' ' .. branch:gsub('%s+', '')
        end
        return ''
      end

      dashboard.section.buttons.val = {
        dashboard.button('f', 'Find', ':Telescope find_files<CR>'),
        dashboard.button('r', 'Recent', ':Telescope oldfiles<CR>'),
        dashboard.button('g', 'Git', ':LazyGit<CR>'),
        dashboard.button('c', 'Commit', ':Telescope git_commits<CR>'),
        dashboard.button('q', 'Quit', ':qa<CR>'),
      }

      dashboard.config.layout = {
        { type = 'padding', val = 2 },
        dashboard.section.header,
        { type = 'padding', val = 2 },
        {
          type = 'text',
          val = function()
            return os.date('󰸗 %a, %b %d · %H:%M')
          end,
          opts = { position = 'center', hl = 'AlphaDate' },
        },
        { type = 'padding', val = 1 },
        {
          type = 'text',
          val = get_links,
          opts = { position = 'center', hl = 'AlphaLinks' },
        },
        { type = 'padding', val = 1 },
        {
          type = 'text',
          val = get_git_info,
          opts = { position = 'center', hl = 'AlphaGit' },
        },
        { type = 'padding', val = 2 },
        dashboard.section.buttons,
      }

      -- Theme
      local colors = {
        header = '#89DCEB', -- sky
        date = '#94E2D5', -- teal
        links = '#89B4FA', -- blue
        git = '#A6E3A1', -- green
        buttons = '#89B4FA', -- blue
      }

      -- Clean UI setup
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function()
          -- Set theme
          vim.api.nvim_set_hl(0, 'AlphaHeader', { fg = colors.header, bold = true })
          vim.api.nvim_set_hl(0, 'AlphaDate', { fg = colors.date })
          vim.api.nvim_set_hl(0, 'AlphaLinks', { fg = colors.links })
          vim.api.nvim_set_hl(0, 'AlphaGit', { fg = colors.git })
          vim.api.nvim_set_hl(0, 'AlphaButtons', { fg = colors.buttons })
          vim.api.nvim_set_hl(0, 'AlphaShortcut', { fg = colors.buttons })

          -- Clean UI
          vim.opt.showtabline = 0
          vim.opt.laststatus = 0
          vim.opt.fillchars = { eob = ' ' }

          -- Button highlights
          for _, button in ipairs(dashboard.section.buttons.val) do
            button.opts.hl = 'AlphaButtons'
            button.opts.hl_shortcut = 'AlphaShortcut'
          end
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaClosed',
        callback = function()
          vim.opt.showtabline = 2
          vim.opt.laststatus = 3
        end,
      })

      alpha.setup(dashboard.config)
    end,
  },
  
  -- File Explorer (Oil - edit filesystem like a buffer)
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('oil').setup({
        default_file_explorer = true,
        columns = {
          'icon',
        },
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,
        keymaps = {
          ['g?'] = 'actions.show_help',
          ['<CR>'] = 'actions.select',
          ['<C-s>'] = 'actions.select_vsplit',
          ['<C-h>'] = 'actions.select_split',
          ['<C-t>'] = 'actions.select_tab',
          ['<C-p>'] = 'actions.preview',
          ['<C-c>'] = 'actions.close',
          ['<Esc>'] = 'actions.close',
          ['q'] = 'actions.close',
          ['<C-l>'] = 'actions.refresh',
          ['-'] = 'actions.parent',
          ['_'] = 'actions.open_cwd',
          ['`'] = 'actions.cd',
          ['~'] = 'actions.tcd',
          ['gs'] = 'actions.change_sort',
          ['gx'] = 'actions.open_external',
          ['g.'] = 'actions.toggle_hidden',
          ['g\\'] = 'actions.toggle_trash',
        },
        use_default_keymaps = true,
        view_options = {
          show_hidden = false,
          is_hidden_file = function(name, bufnr)
            return vim.startswith(name, '.')
          end,
          is_always_hidden = function(name, bufnr)
            return false
          end,
          sort = {
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
        },
        float = {
          padding = 2,
          max_width = 80,  -- Maximum 80 columns wide
          max_height = 20, -- Maximum 20 lines tall
          border = 'rounded',
          win_options = {
            winblend = 10, -- Slight transparency
          },
          override = function(conf)
            -- Center the window
            conf.row = math.floor((vim.o.lines - conf.height) / 2)
            conf.col = math.floor((vim.o.columns - conf.width) / 2)
            return conf
          end,
        },
        preview = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = 0.9,
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
        },
        progress = {
          max_width = 0.9,
          min_width = { 40, 0.4 },
          width = nil,
          max_height = { 10, 0.9 },
          min_height = { 5, 0.1 },
          height = nil,
          border = 'rounded',
          minimized_border = 'none',
          win_options = {
            winblend = 0,
          },
        },
      })
    end,
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
      { '<leader>-', function() require('oil').toggle_float() end, desc = 'Oil Float' },
    },
  },
  
  -- Which-key for keybinding help
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>f', group = '[F]ormat', mode = { 'n', 'v' } },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },
  
  
  -- Todo comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  
  -- Notifications
  {
    'rcarriga/nvim-notify',
    lazy = false,
    priority = 100,
    config = function()
      local notify = require('notify')
      notify.setup({
        timeout = 3000,
        max_height = function()
          return math.floor(vim.o.lines * 0.75)
        end,
        max_width = function()
          return math.floor(vim.o.columns * 0.75)
        end,
        render = 'compact',
        stages = 'fade_in_slide_out',
        background_colour = '#000000',
        on_open = function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end,
      })
      
      -- Set notify as default notify function
      vim.notify = notify
      
      -- Telescope integration
      require('telescope').load_extension('notify')
    end,
  },
  
  -- Noice for better UI (disabled due to errors - can re-enable later)
  -- {
  --   'folke/noice.nvim',
  --   enabled = false, -- Temporarily disabled due to errors
  --   event = 'VeryLazy',
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'rcarriga/nvim-notify',
  --   },
  --   opts = {
  --     lsp = {
  --       override = {
  --         ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
  --         ['vim.lsp.util.stylize_markdown'] = false,
  --         ['cmp.entry.get_documentation'] = false,
  --       },
  --     },
  --     presets = {
  --       bottom_search = false,
  --       command_palette = true,
  --       long_message_to_split = false,
  --       inc_rename = false,
  --       lsp_doc_border = false,
  --     },
  --     routes = {
  --       {
  --         filter = {
  --           event = "msg_show",
  --           kind = "",
  --           find = "written",
  --         },
  --         opts = { skip = true },
  --       },
  --     },
  --   },
  -- },
  
  -- Better status line
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    opts = {
      options = {
        theme = 'auto',
        globalstatus = true,
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = {
          'encoding',
          'fileformat', -- Shows penguin for unix (LF), Windows icon for dos (CRLF)
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      extensions = { 'oil', 'lazy', 'trouble' },
    },
  },
}

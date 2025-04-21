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
  
  -- File Explorer
  {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
      { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
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
  
  -- Mini modules for UI components
  {
    'echasnovski/mini.nvim',
    config = function()
      -- Statusline configuration
      local statusline = require('mini.statusline')
      statusline.setup({ use_icons = vim.g.have_nerd_font })

      -- Custom statusline sections
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
  
  -- Todo comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
  
  -- Avante for notes
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    opts = {},
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
      'zbirenbaum/copilot.lua',
      {
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}

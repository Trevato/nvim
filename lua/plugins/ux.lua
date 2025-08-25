-- Revolutionary UX plugins inspired by the best design principles
return {
  -- Noice.nvim: Complete UI replacement (Raycast-like command palette)
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      cmdline = {
        enabled = true,
        view = 'cmdline_popup', -- Center popup like Raycast
        opts = {},
        format = {
          cmdline = { pattern = '^:', icon = '  ', lang = 'vim' },
          search_down = { kind = 'search', pattern = '^/', icon = ' 󰍉 ', lang = 'regex' },
          search_up = { kind = 'search', pattern = '^%?', icon = ' 󰍉 ', lang = 'regex' },
          filter = { pattern = '^:%s*!', icon = '  ', lang = 'bash' },
          lua = { pattern = { '^:%s*lua%s+', '^:%s*lua%s*=%s*', '^:%s*=%s*' }, icon = '  ', lang = 'lua' },
          help = { pattern = '^:%s*he?l?p?%s+', icon = ' 󰋖 ' },
        },
      },
      messages = {
        enabled = true,
        view = 'notify',
        view_error = 'notify',
        view_warn = 'notify',
        view_history = 'messages',
        view_search = 'virtualtext',
      },
      notify = {
        enabled = true,
        view = 'notify',
      },
      views = {
        notify = {
          -- Slide + fade animation
          render = 'compact',
          stages = 'fade_in_slide_out',
          timeout = 3000,
          top_down = false, -- Notifications from bottom
        },
      },
      popupmenu = {
        enabled = true,
        backend = 'nui',
      },
      lsp = {
        progress = {
          enabled = true,
          view = 'mini',
        },
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = false, -- Handled by blink.cmp
        },
        hover = {
          enabled = true,
          silent = true,
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = true,
            trigger = true,
            luasnip = true,
            throttle = 50,
          },
        },
      },
      presets = {
        bottom_search = false, -- Classic search at bottom
        command_palette = true, -- Raycast-like command palette
        long_message_to_split = true, -- Long messages in split
        inc_rename = false, -- We'll use dressing.nvim
        lsp_doc_border = true, -- Border for hover docs
      },
      views = {
        cmdline_popup = {
          position = {
            row = '40%',
            col = '50%',
          },
          size = {
            width = 60,
            height = 'auto',
          },
        },
      },
      routes = {
        -- Hide annoying messages
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == 'lazy' then
        vim.cmd [[messages clear]]
      end
      require('noice').setup(opts)

      -- Set cmdheight to 0 after Noice loads
      vim.opt.cmdheight = 0
    end,
  },

  -- Beautiful notifications
  {
    'rcarriga/nvim-notify',
    opts = {
      timeout = 3000,
      render = 'compact',
      stages = 'fade',
      fps = 60,
      level = vim.log.levels.INFO,
      minimum_width = 50,
      icons = {
        ERROR = ' ',
        WARN = ' ',
        INFO = ' ',
        DEBUG = ' ',
        TRACE = '󰌷 ',
      },
    },
  },

  -- Removed mini.animate - keeping config minimal

  -- Better input/select UI (like dressing room for Neovim)
  {
    'stevearc/dressing.nvim',
    lazy = false,
    opts = {
      input = {
        enabled = true,
        default_prompt = '➤ ',
        win_options = {
          winblend = 10,
          winhighlight = 'Normal:Normal,NormalFloat:Normal',
        },
      },
      select = {
        enabled = true,
        backend = { 'telescope', 'builtin' },
        builtin = {
          win_options = {
            winblend = 10,
            winhighlight = 'Normal:Normal,NormalFloat:Normal',
          },
        },
      },
    },
  },

  -- Indent guides (subtle, only show scope)
  {
    'echasnovski/mini.indentscope',
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
      symbol = '│',
      options = {
        try_as_border = true,
        border = 'both',
      },
      draw = {
        delay = 0,
        animation = function()
          return 0
        end, -- No animation, instant
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help',
          'dashboard',
          'neo-tree',
          'Trouble',
          'lazy',
          'mason',
          'notify',
          'toggleterm',
          'lazyterm',
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Better fold UI
  {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    event = 'BufRead',
    opts = {
      provider_selector = function()
        return { 'treesitter', 'indent' }
      end,
      open_fold_hl_timeout = 150,
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0,
        },
      },
    },
    init = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
  },

  -- Dashboard (clean startup screen)
  {
    'goolord/alpha-nvim',
    event = 'VimEnter',
    config = function()
      local alpha = require 'alpha'
      local dashboard = require 'alpha.themes.dashboard'

      -- Get current time info
      local function get_greeting()
        local hour = tonumber(os.date '%H')
        local greeting
        if hour < 6 then
          greeting = '● AFTER HOURS ●'
        elseif hour < 12 then
          greeting = '● MORNING SHIFT ●'
        elseif hour < 17 then
          greeting = '● CORE HOURS ●'
        elseif hour < 22 then
          greeting = '● EVENING MODE ●'
        else
          greeting = '● NIGHT OWL ●'
        end
        return greeting
      end

      -- Chicago tech scene header with more detail
      local function get_header()
        -- Get system info
        local hostname = vim.fn.hostname():upper()
        local platform = vim.loop.os_uname().sysname:upper()

        return {
          '',
          '    ╭───────────────────────────────────────────────────────────────╮',
          '    │                                                               │',
          '    │  ████████╗██████╗ ███████╗██╗   ██╗ █████╗ ████████╗ ██████╗  │',
          '    │  ╚══██╔══╝██╔══██╗██╔════╝██║   ██║██╔══██╗╚══██╔══╝██╔═══██╗ │',
          '    │     ██║   ██████╔╝█████╗  ██║   ██║███████║   ██║   ██║   ██║ │',
          '    │     ██║   ██╔══██╗██╔══╝  ╚██╗ ██╔╝██╔══██║   ██║   ██║   ██║ │ ',
          '    │     ██║   ██║  ██║███████╗ ╚████╔╝ ██║  ██║   ██║   ╚██████╔╝ │',
          '    │     ╚═╝   ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝  ╚═╝   ╚═╝    ╚═════╝  │',
          '    │                                                               │',
          '    │     ' .. platform .. ' // ' .. hostname .. string.rep(' ', math.max(0, 48 - #platform - #hostname)) .. '      │',
          '    ╰───────────────────────────────────────────────────────────────╯',
          '',
          '         ' .. get_greeting(),
          '',
        }
      end

      dashboard.section.header.val = get_header()

      -- Clean, minimal buttons with consistent spacing
      dashboard.section.buttons.val = {
        dashboard.button('f', '▸  FIND FILE', ':Telescope find_files <CR>'),
        dashboard.button('r', '▸  RECENT FILES', ':Telescope oldfiles <CR>'),
        dashboard.button('g', '▸  SEARCH TEXT', ':Telescope live_grep <CR>'),
        dashboard.button('n', '▸  NEW FILE', ':ene <BAR> startinsert <CR>'),
        dashboard.button('l', '▸  LAZY PLUGINS', ':Lazy<CR>'),
        dashboard.button('q', '▸  EXIT NEOVIM', ':qa<CR>'),
      }

      -- Footer with dynamic info
      local function get_footer()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return {
          '',
          '────────────────────────────────────────────────',
          '',
          stats.loaded .. '/' .. stats.count .. ' MODULES // ' .. ms .. 'ms BOOT TIME',
          '',
          'CHICAGO // SYSTEM ONLINE',
          '',
          'trevato.dev // github.com/trevato',
        }
      end

      -- Set initial footer (will be updated after lazy loads)
      dashboard.section.footer.val = get_footer()

      -- Styling
      dashboard.section.header.opts.hl = 'AlphaHeader'
      dashboard.section.buttons.opts.hl = 'AlphaButtons'
      dashboard.section.footer.opts.hl = 'AlphaFooter'

      -- Center everything with fade-in animation
      dashboard.opts.layout = {
        { type = 'padding', val = vim.fn.max { 1, vim.fn.floor(vim.fn.winheight(0) * 0.1) } },
        dashboard.section.header,
        { type = 'padding', val = 2 },
        dashboard.section.buttons,
        { type = 'padding', val = 2 },
        dashboard.section.footer,
      }

      -- Realistic neon flicker with Chicago underground tech vibes
      local neon_pink = '#ff00aa'
      local neon_cyan = '#00ffee'
      local neon_white = '#ffffff'
      local off_state = '#2a2a3e'
      local dim_glow = '#4a4a5a'

      -- Start completely off
      vim.cmd('highlight AlphaHeader guifg=' .. off_state .. ' gui=bold')
      vim.cmd('highlight AlphaButtons guifg=' .. off_state)
      vim.cmd('highlight AlphaFooter guifg=' .. off_state)

      -- Realistic power-on flicker sequence
      local flicker_sequence = {
        -- Initial surge attempts
        { header = dim_glow, buttons = off_state, footer = off_state, delay = 80 },
        { header = off_state, buttons = off_state, footer = off_state, delay = 120 },
        { header = neon_pink, buttons = dim_glow, footer = off_state, delay = 20 },
        { header = off_state, buttons = off_state, footer = off_state, delay = 60 },

        -- Second attempt - partial power
        { header = '#ff0088', buttons = '#004455', footer = dim_glow, delay = 40 },
        { header = neon_pink, buttons = '#00aabb', footer = '#ff0066', delay = 30 },
        { header = dim_glow, buttons = off_state, footer = off_state, delay = 50 },

        -- Full power surge
        { header = neon_pink, buttons = neon_cyan, footer = neon_white, delay = 15 },
        { header = '#ff1199', buttons = '#11ffff', footer = '#cccccc', delay = 10 },
        { header = neon_pink, buttons = neon_cyan, footer = neon_white, delay = 25 },
        { header = '#ee0099', buttons = '#00ddcc', footer = '#aaaaaa', delay = 40 },

        -- Stabilize with some flicker
        { header = neon_pink, buttons = neon_cyan, footer = '#cccccc', delay = 80 },
        { header = '#ff0099', buttons = '#00ffdd', footer = '#dddddd', delay = 20 },
        { header = neon_pink, buttons = neon_cyan, footer = '#bbbbbb', delay = 150 },
      }

      -- Execute flicker sequence
      local total_delay = 0
      for _, step in ipairs(flicker_sequence) do
        vim.defer_fn(function()
          vim.cmd('highlight AlphaHeader guifg=' .. step.header .. ' gui=bold')
          vim.cmd('highlight AlphaButtons guifg=' .. step.buttons)
          vim.cmd('highlight AlphaFooter guifg=' .. step.footer)
          vim.cmd 'redraw!'
        end, total_delay)
        total_delay = total_delay + step.delay
      end

      -- Random micro-flickers after stabilization (like real neon)
      vim.defer_fn(function()
        local flicker_timer = vim.loop.new_timer()
        local flicker_count = 0

        flicker_timer:start(
          3000,
          4000,
          vim.schedule_wrap(function()
            -- Random chance of micro-flicker
            if math.random() > 0.7 then
              -- Quick flicker effect
              vim.cmd 'highlight AlphaHeader guifg=#dd0088 gui=bold'
              vim.cmd 'highlight AlphaButtons guifg=#00ddcc'
              vim.defer_fn(function()
                vim.cmd('highlight AlphaHeader guifg=' .. neon_pink .. ' gui=bold')
                vim.cmd('highlight AlphaButtons guifg=' .. neon_cyan)
                vim.cmd 'highlight AlphaFooter guifg=#bbbbbb'
              end, 50)
            end

            -- Occasional complete flicker
            if math.random() > 0.95 then
              vim.cmd('highlight AlphaHeader guifg=' .. dim_glow .. ' gui=bold')
              vim.cmd('highlight AlphaButtons guifg=' .. off_state)
              vim.defer_fn(function()
                vim.cmd('highlight AlphaHeader guifg=' .. neon_pink .. ' gui=bold')
                vim.cmd('highlight AlphaButtons guifg=' .. neon_cyan)
                vim.cmd 'highlight AlphaFooter guifg=#aaaaaa'
              end, 100)
            end

            flicker_count = flicker_count + 1
            if flicker_count > 20 then
              flicker_timer:stop()
            end
          end)
        )
      end, total_delay + 1000)

      -- Update footer with stats after lazy loads
      vim.api.nvim_create_autocmd('User', {
        pattern = 'LazyVimStarted',
        callback = function()
          dashboard.section.footer.val = get_footer()
          pcall(vim.cmd.AlphaRedraw)
        end,
      })

      -- Refresh on focus to update time
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function()
          vim.api.nvim_create_autocmd('FocusGained', {
            buffer = 0,
            callback = function()
              dashboard.section.header.val = get_header()
              vim.cmd 'AlphaRedraw'
            end,
          })
        end,
      })

      -- Hide statusline and tabline in dashboard
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function()
          vim.opt.laststatus = 0
          vim.opt.showtabline = 0
          vim.opt.cmdheight = 0
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaClosed',
        callback = function()
          vim.opt.laststatus = 3
          vim.opt.showtabline = 2
          vim.opt.cmdheight = 0
        end,
      })

      alpha.setup(dashboard.config)
    end,
  },
}

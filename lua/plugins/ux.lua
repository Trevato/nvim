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
        vim.cmd([[messages clear]])
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

  -- Smooth animations (craftzdog + echasnovski patterns)
  {
    'echasnovski/mini.animate',
    event = 'VeryLazy',
    opts = function()
      -- Don't animate when scrolling with mouse
      local mouse_scrolled = false
      for _, scroll in ipairs({ 'Up', 'Down' }) do
        local key = '<ScrollWheel' .. scroll .. '>'
        vim.keymap.set({ '', 'i' }, key, function()
          mouse_scrolled = true
          return key
        end, { expr = true })
      end

      local animate = require('mini.animate')
      return {
        cursor = {
          timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
        },
        scroll = {
          timing = animate.gen_timing.linear({ duration = 150, unit = 'total' }),
          subscroll = animate.gen_subscroll.equal({
            predicate = function(total_scroll)
              if mouse_scrolled then
                mouse_scrolled = false
                return false
              end
              return total_scroll > 1
            end,
          }),
        },
        resize = {
          timing = animate.gen_timing.linear({ duration = 50, unit = 'total' }),
        },
        open = { enable = false }, -- Too distracting
        close = { enable = false }, -- Too distracting
      }
    end,
  },

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
        animation = function() return 0 end, -- No animation, instant
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = {
          'help', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason',
          'notify', 'toggleterm', 'lazyterm',
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
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      
      -- Get current time info
      local function get_greeting()
        local hour = tonumber(os.date('%H'))
        local greeting
        if hour < 12 then
          greeting = '  Good morning'
        elseif hour < 18 then
          greeting = '  Good afternoon'
        else
          greeting = '  Good evening'
        end
        return greeting
      end
      
      -- Get stats
      local function get_stats()
        local stats = require('lazy').stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        return '⚡ ' .. stats.loaded .. '/' .. stats.count .. ' plugins in ' .. ms .. 'ms'
      end
      
      -- Personalized header with real-time info
      local function get_header()
        return {
          '',
          '',
          '████████╗██████╗ ███████╗██╗   ██╗ █████╗ ████████╗ ██████╗ ',
          '╚══██╔══╝██╔══██╗██╔════╝██║   ██║██╔══██╗╚══██╔══╝██╔═══██╗',
          '   ██║   ██████╔╝█████╗  ██║   ██║███████║   ██║   ██║   ██║',
          '   ██║   ██╔══██╗██╔══╝  ╚██╗ ██╔╝██╔══██║   ██║   ██║   ██║',
          '   ██║   ██║  ██║███████╗ ╚████╔╝ ██║  ██║   ██║   ╚██████╔╝',
          '   ╚═╝   ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚═╝  ╚═╝   ╚═╝    ╚═════╝ ',
          '',
          get_greeting(),
          os.date('  %A, %B %d, %Y'),
          '  ' .. os.date('%I:%M %p'),
          '',
        }
      end
      
      dashboard.section.header.val = get_header()
      
      -- Clean, minimal buttons with consistent spacing
      dashboard.section.buttons.val = {
        dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
        dashboard.button('r', '  Recent', ':Telescope oldfiles <CR>'),
        dashboard.button('g', '  Grep', ':Telescope live_grep <CR>'),
        dashboard.button('n', '  New', ':ene <BAR> startinsert <CR>'),
        dashboard.button('s', '  Session', ':SessionRestore <CR>'),
        dashboard.button('l', '  Lazy', ':Lazy<CR>'),
        dashboard.button('q', '  Quit', ':qa<CR>'),
      }
      
      -- Footer with links and stats
      dashboard.section.footer.val = {
        '',
        '───────────────────────────────────────────────',
        '',
        '  trevato.dev   •     github.com/trevato',
        '',
        get_stats(),
        '',
      }
      
      -- Styling
      dashboard.section.header.opts.hl = 'Function'
      dashboard.section.buttons.opts.hl = 'Normal'
      dashboard.section.footer.opts.hl = 'Comment'
      
      -- Center everything
      dashboard.opts.layout = {
        { type = 'padding', val = vim.fn.max({ 1, vim.fn.floor(vim.fn.winheight(0) * 0.1) }) },
        dashboard.section.header,
        { type = 'padding', val = 2 },
        dashboard.section.buttons,
        { type = 'padding', val = 2 },
        dashboard.section.footer,
      }
      
      -- Refresh on focus to update time
      vim.api.nvim_create_autocmd('User', {
        pattern = 'AlphaReady',
        callback = function()
          vim.api.nvim_create_autocmd('FocusGained', {
            buffer = 0,
            callback = function()
              dashboard.section.header.val = get_header()
              dashboard.section.footer.val[6] = get_stats()
              vim.cmd('AlphaRedraw')
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
return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

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
      local branch_handle = io.popen 'git branch --show-current 2>/dev/null'
      if not branch_handle then
        return ''
      end
      local branch = branch_handle:read '*l'
      branch_handle:close()

      if branch and branch ~= '' then
        local commit_handle = io.popen 'git log -1 --pretty=format:"%h %s" 2>/dev/null'
        if not commit_handle then
          return ' ' .. branch
        end
        local commit = commit_handle:read '*l'
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
      dashboard.button('g', 'Git', ':Telescope git_status<CR>'),
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
          return os.date '󰸗 %a, %b %d · %H:%M'
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
}

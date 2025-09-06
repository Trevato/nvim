-- LSP configuration optimized for blink.cmp
return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      local lspconfig = require('lspconfig')
      
      -- Get blink.cmp capabilities (required for proper completion)
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      
      -- TypeScript/JavaScript (vtsls is 5x faster than ts_ls)
      lspconfig.vtsls.setup({
        capabilities = capabilities,
        settings = {
          complete_function_calls = true,
          vtsls = {
            enableMoveToFileCodeAction = true,
            autoUseWorkspaceTsdk = true,
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
                entriesLimit = 75,
              },
            },
          },
          typescript = {
            updateImportsOnFileMove = { enabled = 'always' },
            suggest = {
              completeFunctionCalls = true,
              includeCompletionsForModuleExports = true,
              includeAutomaticOptionalChainCompletions = true,
            },
            preferences = {
              preferTypeOnlyAutoImports = true,
            },
          },
        },
      })
      
      -- Python - using basedpyright (modern fork with better features)
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Use dynamic python path detection
          local function get_python_path(workspace)
            -- Check for uv virtual environment first
            local uv_python = workspace .. '/.venv/bin/python'
            if vim.fn.filereadable(uv_python) == 1 then
              return uv_python
            end
            
            -- Check for standard venv
            local venv_python = workspace .. '/venv/bin/python'
            if vim.fn.filereadable(venv_python) == 1 then
              return venv_python
            end
            
            -- Fallback to system python
            return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
          end
          
          client.config.settings.python = vim.tbl_deep_extend('force', client.config.settings.python or {}, {
            pythonPath = get_python_path(client.config.root_dir)
          })
        end,
        settings = {
          basedpyright = {
            disableOrganizeImports = true, -- Let Ruff handle this
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              typeCheckingMode = 'standard', -- 'strict' for more checks, 'off' for linting-only
              diagnosticMode = 'openFilesOnly', -- 'workspace' for all files
              autoImportCompletions = true,
              diagnosticSeverityOverrides = {
                reportUnusedImport = 'information',
                reportUnusedVariable = 'information',
              },
            },
          },
          python = {
            venvPath = '.',
          },
        },
      })
      
      -- Ruff for ultra-fast Python linting/formatting
      lspconfig.ruff.setup({
        capabilities = capabilities,
        on_attach = function(client, _)
          -- Disable hover in favor of basedpyright
          client.server_capabilities.hoverProvider = false
        end,
        init_options = {
          settings = {
            -- Ruff settings
            args = {},
          },
        },
      })
      
      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      })
      
      -- ESLint (if available)
      pcall(function()
        lspconfig.eslint.setup({
          capabilities = capabilities,
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
        })
      end)
      
      -- Keymaps on LSP attach
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          
          -- Navigation
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          
          -- Actions
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
          
          -- Signature help
          vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, opts)
        end,
      })
      
      -- Diagnostics
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
      
      -- Diagnostic signs
      local signs = { Error = '󰅚 ', Warn = '󰀪 ', Hint = '󰌶 ', Info = ' ' }
      for type, icon in pairs(signs) do
        local hl = 'DiagnosticSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
      
      -- LSP debugging helper command
      vim.api.nvim_create_user_command('LspDebug', function()
        local clients = vim.lsp.get_active_clients()
        if #clients == 0 then
          print('No active LSP clients')
          return
        end
        for _, client in ipairs(clients) do
          print(string.format('LSP: %s (id=%d, root=%s)', client.name, client.id, client.config.root_dir or 'none'))
        end
      end, { desc = 'Show active LSP clients' })
      
      -- Python path debug command
      vim.api.nvim_create_user_command('PythonPath', function()
        local clients = vim.lsp.get_active_clients({ name = 'basedpyright' })
        if #clients == 0 then
          print('basedpyright is not running')
          return
        end
        local client = clients[1]
        local python_path = client.config.settings.python and client.config.settings.python.pythonPath or 'not set'
        print('Python path: ' .. python_path)
      end, { desc = 'Show Python path used by basedpyright' })
    end,
  },
}
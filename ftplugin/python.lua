-- Python-specific settings and keybindings
-- This file is automatically sourced for Python files

-- Set Python-specific options
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.textwidth = 88 -- Black/Ruff default line length

-- Python-specific keybindings
local opts = { buffer = true, silent = true }

-- Quick imports
vim.keymap.set('n', '<leader>pi', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { 'source.organizeImports' },
    },
  })
end, vim.tbl_extend('force', opts, { desc = 'Organize imports' }))

-- Python debugging helpers
vim.keymap.set('n', '<leader>pb', 'obreakpoint()<Esc>', vim.tbl_extend('force', opts, { desc = 'Insert breakpoint()' }))
vim.keymap.set('n', '<leader>pB', 'Obreakpoint()<Esc>', vim.tbl_extend('force', opts, { desc = 'Insert breakpoint() above' }))

-- Quick print statement
vim.keymap.set('n', '<leader>pp', 'oprint(f"{=}")<Esc>2F{a', vim.tbl_extend('force', opts, { desc = 'Insert print statement' }))
vim.keymap.set('v', '<leader>pp', 'yoprint(f"<C-r>": {<C-r>"=}")<Esc>', vim.tbl_extend('force', opts, { desc = 'Print selection' }))

-- Type annotations
vim.keymap.set('n', '<leader>pt', function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { 'source.addMissingImports', 'source.fixMissingImports' },
    },
  })
end, vim.tbl_extend('force', opts, { desc = 'Add type imports' }))

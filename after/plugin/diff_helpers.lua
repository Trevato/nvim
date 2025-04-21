-- Simple and direct keymaps for diff mode
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.o.diff then
      -- Direct key mappings that should work in any Neovim instance
      vim.keymap.set('n', ']c', ']c', { buffer = true, silent = true })
      vim.keymap.set('n', '[c', '[c', { buffer = true, silent = true })
      
      -- Simple mappings that don't rely on <leader>
      vim.keymap.set('n', 'gl', ':diffget LOCAL<CR>', { buffer = true, silent = true })
      vim.keymap.set('n', 'gr', ':diffget REMOTE<CR>', { buffer = true, silent = true })
      vim.keymap.set('n', 'gq', ':wqa<CR>', { buffer = true, silent = true })
      
      -- Print the help message
      vim.defer_fn(function()
        print("DIFF MODE KEYS: ]c/[c = next/prev diff | gl = use LOCAL | gr = use REMOTE | gq = save and quit")
      end, 1000)
    end
  end
})

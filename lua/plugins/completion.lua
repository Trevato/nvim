-- Completion and snippets (MINIMAL VERSION TO FIX ERRORS)
return {
  -- Autocompletion - DISABLED DUE TO PERSISTENT ERRORS
  -- We'll use built-in completion for now
  {
    'hrsh7th/nvim-cmp',
    enabled = false, -- DISABLED until we fix the issue
  },
  
  -- Keep LuaSnip for snippets
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    config = function()
      require('luasnip').setup({
        history = true,
        delete_check_events = 'TextChanged',
      })
    end,
  },
}
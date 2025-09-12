-- Modern, fast completion with blink.cmp
return {
  {
    'saghen/blink.cmp',
    version = 'v0.*',
    event = 'InsertEnter', -- Lazy load on insert mode
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    opts = {
      -- Simple, working configuration
      keymap = { preset = 'default' },
      
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono',
      },
      
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      
      completion = {
        documentation = {
          auto_show = true,
        },
      },
    },
  },
}
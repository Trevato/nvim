-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'trevato/alpine.nvim',
  dir = '/users/trevato/projects/alpine.nvim', -- Point to your local repo
  lazy = false,
  priority = 1000,
  config = function()
    require('alpine').setup {
      transparent = true,
      italic_comments = true,
      bold_keywords = true,

      integrations = {
        treesitter = true,
        telescope = true,
        nvimtree = true,
        lsp = true,
      },
    }
  end,
}

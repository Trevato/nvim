-- Minimal init.lua - loads modular configuration

-- Set <space> as the leader key
-- Must happen before plugins are loaded
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- Load core modules
require('core.options')    -- vim options
require('core.keymaps')    -- global keymaps
require('core.autocmds')   -- autocommands
require('core.plugins')    -- plugin management

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

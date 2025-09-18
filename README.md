# Neovim Config

Performance-focused config with transparent UI and proper terminal integration.

## Key Features

### Transparent UI
- All UI elements (winbar, statusline, tabline) have transparent backgrounds
- Window titles show current filename at top of each split
- Terminal title shows `nvim:project/file` format

### Terminal Integration
- `:Shell <cmd>` - Run commands with live output (replaces `:!`)
- `<leader>tt` - Persistent terminal at bottom
- `<leader>t1/t2/t3` - Multiple terminal sessions
- `<leader>tf` - Floating terminal
- Live output streams to terminal buffer, not frozen like native `:!`

### Command Palette
- Noice.nvim provides Raycast-like command palette in center of screen
- Shell commands show "Shell Command" label instead of "filter"
- Command history searchable via Telescope (`<leader>sc`)

### Performance
- Sub-40ms startup time
- Lazy loading for all plugins
- blink.cmp instead of nvim-cmp (10x faster)
- Disabled treesitter-context to avoid duplicate displays

## Workflows

### Running Commands
Instead of `:!npm run dev`, use `:Shell npm run dev` for live output.
Access command history with `<leader>sh` or search with `<leader>sc`.

### File Navigation
- `-` opens Oil.nvim to edit filesystem like a buffer
- `<leader>sf` for file search
- `<leader>sg` for grep
- `<leader><leader>` for buffer switching

### Git
- `<leader>gg` for LazyGit
- Gitsigns in gutter for inline changes

## Non-Standard Keybinds

- `<leader>sl` - Last command output
- `<leader>sh` - Command history
- `<leader>tr` - Run command with prompt
- `<leader>un` - Dismiss notifications
- `<leader>ue` - Copy errors to clipboard

## Requirements

- Neovim 0.10+
- Nerd Font
- ripgrep, fd for searching
- Node.js for LSPs
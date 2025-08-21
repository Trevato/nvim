# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is a Neovim configuration based on kickstart.nvim, using Lua for all configuration. The setup is modular with lazy-loading plugins managed by lazy.nvim.

## Key Architecture

### Plugin Organization
- **lazy.nvim** manages all plugins with auto-loading from `lua/plugins/`
- Each plugin module returns a table of plugin specifications
- Plugins are lazy-loaded based on events, commands, or filetypes for performance

### Module Structure
```
lua/
├── core/          # Core configuration (loaded first)
│   ├── options    # Vim options and settings
│   ├── keymaps    # Global keybindings
│   ├── autocmds   # Autocommands
│   └── plugins    # Plugin manager setup
├── plugins/       # Plugin configurations (auto-imported)
│   ├── completion # Autocompletion (nvim-cmp, LuaSnip)
│   ├── editor     # Editor enhancements (Telescope, Treesitter, formatting)
│   ├── lsp        # Language Server Protocol setup
│   ├── git        # Git integration (gitsigns, diffview, lazygit)
│   └── ui         # UI improvements
└── kickstart/     # Optional kickstart modules
```

## Common Development Commands

### Plugin Management
```bash
# Open lazy.nvim UI
:Lazy

# Update plugins
:Lazy update

# Check plugin health
:checkhealth
```

### Formatting & Linting
- **Format current file**: `<leader>f` or `:lua require('conform').format()`
- **Organize imports**: `<leader>fo` (for TypeScript/JavaScript with Biome)
- **Toggle auto-format**: `<leader>tf`
- **Trigger linting**: `<leader>l`
- **Check format status**: `<leader>?f`

The config automatically detects and uses project-specific tools:
- **JavaScript/TypeScript**: Prefers Biome if `biome.json` exists, falls back to ESLint/Prettier
- **Python**: Uses Ruff for both linting and formatting
- **Lua**: Uses Stylua

### LSP Operations
- **Go to definition**: `gd`
- **Find references**: `gr`
- **Rename symbol**: `<leader>rn`
- **Code action**: `<leader>ca`
- **Show diagnostics**: `<leader>q`

### File Navigation
- **Find files**: `<leader>sf`
- **Live grep**: `<leader>sg`
- **Search buffers**: `<leader><leader>`
- **Recent files**: `<leader>s.`
- **Search Neovim config**: `<leader>sn`
- **File explorer**: `-` (Oil.nvim - edit filesystem like a buffer)
- **File explorer float**: `<leader>-`

### Error & Notification Management
- **Dismiss notifications**: `<leader>un`
- **View notification history**: `<leader>uN`
- **Copy errors to clipboard**: `<leader>ue` or `:CopyErrors`
- **Debug info**: `:DebugInfo`, `:DebugErrors`, `:DebugPlugins`

## Testing & Validation
Before committing changes to this config:
1. Restart Neovim to ensure no load errors
2. Run `:checkhealth` to verify all plugins are working
3. Test key bindings aren't conflicting
4. Verify LSP servers are properly attached with `:LspInfo`

## Mason-Managed Tools
Language servers, linters, and formatters are installed via Mason. Check installed tools with `:Mason`. The config expects these tools to be available:
- **Python**: pyright, ruff
- **JavaScript/TypeScript**: vtsls (5x faster than ts_ls), eslint, biome (preferred) or prettier
- **Lua**: lua_ls, stylua

## Plugin-Specific Notes

### AI Assistance
- **Supermaven**: Ultra-fast AI autocomplete (10x faster than Copilot). Accept with `Ctrl-j`.
- **Copilot**: GitHub Copilot as fallback. Requires authentication via `:Copilot auth`.
- **CopilotChat**: AI chat via `<leader>cc`

### Completion (Temporary - nvim-cmp disabled due to errors)
- **Trigger completion**: `Ctrl-Space`
- **Next/Previous item**: `Ctrl-n` / `Ctrl-p`
- **Confirm**: `Ctrl-y`
- **Cancel**: `Ctrl-e`

### Navigation
- **Oil.nvim**: File explorer that works like a buffer. Press `-` to open, edit filenames directly
- **Flash**: Lightning-fast navigation with `s` in normal mode
- **Harpoon**: Quick file switching. Add with `<leader>a`, toggle menu with `<C-e>`, jump to files with `<leader>1-4`
- **Trouble**: Better diagnostics with `<leader>xx`

### Git Integration
- LazyGit integration via `<leader>gg`
- Diffview for reviewing changes
- Gitsigns for inline git status

### UI Enhancements
- **Lualine**: Enhanced statusline with git and diagnostics info
- **TokyoNight**: Primary theme with transparency support
- **nvim-notify**: Better notification system with history

### Debugging
DAP (Debug Adapter Protocol) is configured for Python and JavaScript. Debuggers are auto-installed via Mason-nvim-dap.

## Performance Considerations
- Plugins are lazy-loaded to maintain fast startup times
- Treesitter parsers are auto-installed but limited to essential languages
- Format-on-save is disabled by default (toggle with `<leader>tf`)
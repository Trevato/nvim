# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Philosophy & Design Principles

### Core Values
- **Minimalist Beauty**: Every line has purpose, every plugin earns its place
- **Performance First**: Sub-40ms startup, instant response, no lag
- **Designer Aesthetic**: Subtle, refined, professional - like a well-designed product
- **Developer Friendly**: Intuitive for newcomers, powerful for experts

### Influences
- **folke's patterns**: Lazy loading, modular organization, snacks.nvim utilities
- **TJ DeVries approach**: Leverage built-in Neovim features first
- **ThePrimeagen's speed**: Performance obsession, minimal overhead
- **Tokyo Night aesthetic**: Modern, clean, designer-friendly colors

## Repository Overview
Modern Neovim configuration evolved from kickstart.nvim, optimized for speed and beauty. Uses Lua exclusively with lazy.nvim plugin management and blink.cmp for blazing-fast completion.

## Key Architecture

### Plugin Management
- **lazy.nvim** with `defaults = { lazy = true }` for optimal loading
- Plugins organized by category in `lua/plugins/`
- Event-driven loading (`VeryLazy`, `BufReadPre`, etc.)
- Performance monitoring with `:Lazy profile`

### Module Structure
```
lua/
├── core/          # Core configuration (loaded first)
│   ├── options    # Vim options and settings
│   ├── keymaps    # Global keybindings
│   ├── autocmds   # Autocommands
│   ├── plugins    # Plugin manager setup with performance opts
│   └── debug      # Debug helpers
├── plugins/       # Plugin configurations (auto-imported)
│   ├── completion # blink.cmp - 10x faster than nvim-cmp
│   ├── editor     # Telescope, Treesitter, formatting
│   ├── lsp        # Language Server Protocol setup
│   ├── git        # Git integration (gitsigns, diffview, lazygit)
│   ├── ui         # UI improvements
│   ├── performance# Performance optimizations
│   └── animations # Subtle, tasteful animations
└── kickstart/     # Optional kickstart modules (being phased out)
```

### Performance Optimizations
- Lazy loading by default for all plugins
- Disabled built-in plugins (netrw, matchparen, etc.)
- Cached plugin loading
- Minimal treesitter parsers
- Smart file size detection with bigfile.nvim

## Common Development Commands

### Plugin Management
```vim
:Lazy             " Open lazy.nvim UI
:Lazy update      " Update plugins
:Lazy profile     " Check startup performance
:Lazy reload      " Reload plugin specs
```

### Formatting & Linting
- **Format**: `<leader>f` - Uses conform.nvim with project-specific tools
- **Toggle auto-format**: `<leader>tf`
- **Biome** preferred for JS/TS if `biome.json` exists
- **Ruff** for Python (both linting and formatting)
- **Stylua** for Lua

### LSP Operations
- **Go to definition**: `gd`
- **Find references**: `gr`
- **Rename symbol**: `<leader>rn`
- **Code action**: `<leader>ca`
- **Hover docs**: `K`
- **Signature help**: `<C-k>` (insert mode)

### File Navigation
- **Find files**: `<leader>sf` (Telescope)
- **Live grep**: `<leader>sg`
- **Search buffers**: `<leader><leader>`
- **Recent files**: `<leader>s.`
- **Config files**: `<leader>sn`
- **File explorer**: `-` (Oil.nvim - edit like a buffer)

### Terminal & Git
- **LazyGit**: `<leader>gg` (via snacks.nvim)
- **Terminal**: `<leader>tt` (floating terminal)
- **Git signs**: See changes in gutter
- **Diffview**: Review git changes

### Notifications & Errors
- **Dismiss notifications**: `<leader>un`
- **Copy errors**: `<leader>ue`
- **Debug commands**: `:DebugInfo`, `:DebugErrors`

## Plugin Ecosystem

### Core Utilities
- **snacks.nvim**: Swiss army knife (terminal, notifications, dashboard, etc.)
- **lazy.nvim**: Plugin manager with performance focus
- **telescope.nvim**: Fuzzy finder for everything
- **oil.nvim**: File management as text editing

### Completion & AI
- **blink.cmp**: Ultra-fast completion (10x faster than nvim-cmp)
- **Supermaven**: Fastest AI autocomplete (10x faster than Copilot)
- **Copilot**: Fallback AI assistance
- **CopilotChat**: AI chat with `<leader>cc`

### Editor Enhancement
- **treesitter**: Syntax highlighting and code understanding
- **conform.nvim**: Auto-formatting with project tool detection
- **nvim-lint**: Async linting
- **mini.nvim modules**: Surround, AI text objects, indentscope

### Performance Features
- **bigfile.nvim**: Disables features for large files
- **garbage-day.nvim**: LSP garbage collection
- **neoscroll.nvim**: Smooth scrolling
- **vim-startuptime**: Profile startup with `:StartupTime`

## Testing & Validation

Before committing changes:
1. **Restart Neovim** - Ensure no load errors
2. **Run `:checkhealth`** - Verify plugin health
3. **Check `:Lazy profile`** - Startup should be <50ms
4. **Test LSP**: `:LspInfo` shows attached servers
5. **Verify keymaps**: `:Telescope keymaps` for conflicts

## Mason-Managed Tools

Auto-installed via Mason:
- **Python**: pyright, ruff
- **JavaScript/TypeScript**: vtsls (5x faster), eslint, biome
- **Lua**: lua_ls, stylua
- **Debuggers**: Auto-installed via mason-nvim-dap

## Performance Benchmarks

Target metrics:
- **Startup time**: <40ms
- **File open**: Instant (<10ms)
- **Completion popup**: <50ms
- **LSP response**: <100ms
- **Search results**: <200ms for large projects

## Common Patterns & Best Practices

### Adding a New Plugin
```lua
-- In appropriate lua/plugins/*.lua file
{
  'author/plugin-name',
  event = 'VeryLazy',  -- Or specific trigger
  dependencies = { 'required/dep' },
  opts = {
    -- Configuration here
  },
}
```

### LSP Server Addition
```lua
-- In lua/plugins/lsp.lua
lspconfig.new_server.setup({
  capabilities = capabilities,  -- From blink.cmp
  settings = {
    -- Server-specific settings
  },
})
```

### Keymap Addition
```lua
-- In lua/core/keymaps.lua or plugin config
vim.keymap.set('n', '<leader>xx', function() 
  -- Action here
end, { desc = 'Clear description' })
```

## Troubleshooting

### Performance Issues
1. Run `:Lazy profile` to identify slow plugins
2. Check `:StartupTime` for detailed breakdown
3. Verify bigfile.nvim is working for large files
4. Ensure garbage-day.nvim is cleaning LSP memory

### Completion Problems
1. Verify blink.cmp is loaded: `:Lazy show blink.cmp`
2. Check LSP attachment: `:LspInfo`
3. Test with `:lua =require('blink.cmp').get_lsp_capabilities()`

### UI/Theme Issues
1. Verify terminal supports true color: `:CheckHealth`
2. Check transparency settings in theme config
3. Ensure Nerd Font is installed and selected

## Important Notes

- **No nvim-cmp**: We use blink.cmp for 10x better performance
- **Lazy by default**: All plugins lazy load unless explicitly needed
- **Project tools first**: Biome > Prettier, Ruff > Black
- **Built-in features**: Prefer Neovim 0.10+ native capabilities
- **Minimal dependencies**: Each plugin must justify its inclusion

## AI Assistance Guidelines

When working with this config:
1. **Preserve performance**: Don't add plugins without lazy loading
2. **Maintain aesthetics**: Keep the minimalist, designer approach
3. **Test changes**: Always verify with `:checkhealth` after modifications
4. **Document clearly**: Update this file when adding significant features
5. **Follow patterns**: Use existing code style and organization

Remember: This config prioritizes speed, beauty, and developer experience. Every addition should enhance, not compromise, these values.
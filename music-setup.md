# Strudel Music Setup for Neovim

## Quick Start

### 1. Add Shell Alias
Add this to your `~/.zshrc`:

```bash
# Neovim music mode for live coding with Strudel
alias nvim-music='NVIM_MUSIC=1 nvim'
```

Then reload your shell:
```bash
source ~/.zshrc
```

### 2. Install Plugin Dependencies
When you first launch music mode, the plugin will build its npm dependencies:

```bash
nvim-music
# Then in Neovim:
:Lazy sync
```

### 3. Start Making Music
```bash
# Create a new music file
nvim-music ~/music/my-beat.str

# In Neovim:
<leader>ms  # Launch Strudel (opens browser)
<leader>mt  # Toggle play/pause
<leader>mu  # Update pattern while playing
```

## Key Bindings (Music Mode Only)

| Key | Action |
|-----|--------|
| `<leader>ms` | Start Strudel session |
| `<leader>mt` | Toggle playback |
| `<leader>mu` | Update/evaluate code |
| `<leader>mq` | Quit Strudel |
| `<leader>mx` | Stop playback |
| `<leader>me` | Execute buffer |
| `<leader>mh` | Execute with visuals |

## Performance Notes

- **Zero impact** on normal Neovim usage (plugin only loads with NVIM_MUSIC=1)
- Uses ~300MB RAM for browser automation
- Headless mode enabled by default to reduce GPU usage
- Browser cache stored in `~/.cache/strudel-nvim/`

## Troubleshooting

### Browser not launching?
- Ensure you have Chrome, Chromium, Edge, or Brave installed
- Check npm dependencies: `cd ~/.local/share/nvim/lazy/strudel.nvim && npm install`

### High memory usage?
- Normal due to Puppeteer/Chromium (300MB+)
- Use only for dedicated music sessions
- Quit with `<leader>mq` when done

### File type not detected?
- Ensure files have `.str` extension
- Music mode must be active (NVIM_MUSIC=1)

## Learn Strudel

- Official docs: https://strudel.cc/learn/
- Pattern reference: https://strudel.cc/learn/mini-notation/
- Examples: https://strudel.cc/examples/
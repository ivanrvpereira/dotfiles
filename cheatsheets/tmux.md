# tmux cheatsheet

Prefix: `Ctrl-a`

## Sessions

| Key | Action |
|-----|--------|
| `tmux new -s name` | New session |
| `tmux ls` | List sessions |
| `tmux a -t name` | Attach to session |
| `prefix d` | Detach |
| `prefix $` | Rename session |
| `prefix s` | Session picker |

## Windows

| Key | Action |
|-----|--------|
| `prefix c` | New window (keeps cwd) |
| `prefix ,` | Rename window |
| `prefix &` | Close window |
| `prefix C-n` | Next window |
| `prefix C-p` | Previous window |
| `F1`-`F5` | Switch to window 1-5 |

## Panes

| Key | Action |
|-----|--------|
| `prefix \|` | Split horizontal |
| `prefix -` | Split vertical |
| `prefix h/j/k/l` | Navigate panes |
| `Ctrl-h/j/k/l` | Navigate panes (vim-tmux-navigator) |
| `prefix x` | Kill pane (no confirm) |
| `prefix <` | Swap pane up |
| `prefix >` | Swap pane down |
| `prefix C-j` | Move pane to window |
| `prefix z` | Toggle pane zoom |
| `prefix Arrow` | Resize pane (repeatable) |

## Copy Mode (vi)

| Key | Action |
|-----|--------|
| `prefix v` | Enter copy mode |
| `v` | Begin selection |
| `y` | Yank to clipboard (exits copy mode) |
| Mouse drag | Yank to clipboard (exits copy mode) |
| `prefix p` | Paste buffer |
| `/` | Search forward |
| `?` | Search backward |
| `n` / `N` | Next / previous search match |
| `prefix y` | Toggle sticky yank (stay in copy mode) |

## Utilities

| Key | Action |
|-----|--------|
| `prefix r` | Reload config |
| `prefix m` | FZF file picker popup |
| `prefix C-h` | btop in split |
| `prefix t` | todo.md in split |

## Plugins

- **tmux-yank** — system clipboard integration
- **vim-tmux-navigator** — seamless vim/tmux pane nav
- **tmux-resurrect** — save/restore sessions (`prefix C-s` / `prefix C-r`)
- **tmux-continuum** — auto-save every 15 min, auto-restore on start
- **dracula** — theme

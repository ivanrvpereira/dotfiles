# dotfiles

Modern dotfiles for macOS managed with [GNU Stow](https://www.gnu.org/software/stow/), featuring Fish shell, Starship prompt, and contemporary CLI tools.

## Quick Setup

On a fresh Mac, run:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/ivanrvpereira/dotfiles/master/bootstrap.sh)
```

Or if you've already cloned the repo:

```bash
~/.dotfiles/bootstrap.sh
```

The bootstrap script handles everything: Xcode CLT, Homebrew, packages, Fish as default shell, stow symlinks, pre-commit hooks, mise runtimes, and TPM.

### Post-Bootstrap

1. Open a new terminal (or restart your shell)
2. Run `tmux` then press `Ctrl-a I` to install tmux plugins
3. Copy `git/gitconfig.local.example` to `~/.gitconfig.local` and fill in your details
4. Run `auth` to load ephemeral secrets (1Password)

## Structure

Dotfiles are organized as **GNU Stow packages** — each directory maps to `$HOME`:

```
~/.dotfiles/
├── git/              → ~/.gitconfig, ~/.gitignore
├── fish/             → ~/.config/fish/{config,exports,aliases,activate}.fish
├── tmux/             → ~/.tmux.conf
├── tmuxinator/       → ~/.config/tmuxinator/dev.yml
├── ghostty/          → ~/.config/ghostty/config
├── aerospace/        → ~/.aerospace.toml, ~/.config/aerospace/center-window.sh
├── atuin/            → ~/.config/atuin/config.toml
├── btop/             → ~/.config/btop/btop.conf
├── htop/             → ~/.config/htop/htoprc
├── zed/              → ~/.config/zed/settings.json
├── mise/             → ~/.config/mise/config.toml
├── Brewfile          → Homebrew packages, casks, fonts, Mac App Store apps
└── bootstrap.sh      → One-command setup for fresh machines
```

### Stow Commands

```bash
# Deploy a package (creates symlinks)
stow --no-folding -R git

# Deploy all packages
stow --no-folding -R git tmux tmuxinator fish ghostty aerospace atuin btop htop zed mise nvim lazygit

# Remove a package's symlinks
stow -D git
```

## Package Management

| Layer | Tool | Manages | Config |
|-------|------|---------|--------|
| **System packages** | Homebrew | CLI tools, casks, fonts, App Store apps | `Brewfile` |
| **Runtimes & dev tools** | mise | node, python, go, rust, java, lua, uv, pipx tools | `mise/.config/mise/config.toml` |

## Shell (Fish)

Fish config sources three files in order:

1. `exports.fish` — PATH, environment variables, Homebrew prefix
2. `aliases.fish` — Modern CLI replacements, abbreviations, commands
3. `activate.fish` — Starship prompt, mise activation, atuin, 1Password plugins

### Modern CLI Replacements

| Instead of | Use | Alias |
|------------|-----|-------|
| `cat` | `bat` | `cat` |
| `ls` | `eza` | `ls`, `l`, `ll`, `la`, `lt` |
| `find` | `fd` | `find` |
| `grep` | `rg` | `search` |
| `sed` | `sd` | — |
| `cd` | `z` (zoxide) | `cd`, `cdi` |
| `rm` | `trash` | `rm` (safe), `del` (real rm) |
| `vim` | `nvim` | `vim`, `vi` |
| `top` | `btop` | — |
| `du` | `dua` | `du` |

### Key Aliases

```fish
update          # Full system update: macOS + Homebrew + Brewfile + mise
bb              # brew bundle from Brewfile
brewcheck       # Diff Brewfile vs installed packages
cleanup         # Remove .DS_Store files recursively
lg              # lazygit
mux             # tmuxinator
auth            # Load ephemeral secrets from 1Password
secret-scan     # Gitleaks scan on current repo
```

## Tmux

- **Prefix:** `Ctrl-a`
- **Vi mode** enabled
- **Pane navigation:** `prefix + h/j/k/l` and `Ctrl-h/j/k/l` (vim-tmux-navigator)
- **Window switching:** `F1`–`F5`
- **Reload config:** `prefix + r`
- **Theme:** Dracula
- **Plugins:** TPM, vim-tmux-navigator, tmux-yank, tmux-resurrect, tmux-continuum

## Git

- Default branch: `main`
- Auto-setup rebase on pull, auto-prune on fetch
- `push.autoSetupRemote = true`
- Auth via `gh` CLI
- Local overrides in `~/.gitconfig.local` (untracked — see `git/gitconfig.local.example`)

## Security

- **Secret scanning:** Gitleaks pre-commit hook prevents accidental secret commits
- **1Password SSH agent:** SSH keys managed by 1Password, no keys on disk
- **Ephemeral secrets:** API keys loaded from 1Password into `$TMPDIR` (cleared on reboot)

```bash
secret-scan           # Scan current state
secret-scan-history   # Scan entire git history
secret-scan-verified  # Verify detected secrets are real (trufflehog)
hooks-run             # Manually run pre-commit hooks
```

## Maintenance

```bash
update                # Full update: macOS + Homebrew + Brewfile + mise
mise install          # Install/update all runtimes
mise upgrade          # Upgrade all mise-managed tools
brew bundle cleanup   # Find orphaned Homebrew packages
source ~/.config/fish/config.fish   # Reload fish config
tmux source-file ~/.tmux.conf       # Reload tmux (or prefix + r)
```

## VPS / Linux

Only a subset applies on Linux servers: git, tmux, fish, atuin. No Homebrew — use `apt` for system packages and `mise` for cross-platform CLI tools.

```bash
sudo apt install -y git tmux fish
curl https://mise.run | sh
mise install
```

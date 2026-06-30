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
├── nvim/             → ~/.config/nvim/ (LazyVim)
├── lazygit/          → ~/Library/Application Support/lazygit/config.yml
├── launchd/          → ~/Library/LaunchAgents/*.plist (scheduled tasks)
├── bin/              → Scripts (in PATH via ~/.dotfiles/bin)
├── Brewfile          → Homebrew packages, casks, fonts, Mac App Store apps
├── Aptfile           → Ubuntu/Debian development server packages
├── mise-linux-tools.txt → Linux-only mise tools also installed by Brewfile on macOS
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
| **macOS system packages** | Homebrew | CLI tools, casks, fonts, App Store apps | `Brewfile` |
| **Ubuntu/Debian server packages** | apt | headless CLI/dev/server tools | `Aptfile` |
| **Linux-only fast CLIs** | mise wrappers | gh, awscli, gitleaks, yq, kubectl, etc. | `mise-linux-tools.txt` + `bin/install-linux-mise-tools` |
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

## Scheduled Tasks (launchd)

Automated updates run via macOS launchd agents, opening a Terminal.app window so you can see progress:

| Job | Schedule | What it does |
|-----|----------|-------------|
| `update-agents` | Daily 7 AM | AI tools: claude-code, gemini-cli, pi, skills |
| `update-system` | Wednesday noon | brew, mise, macOS software updates |

Plists are managed as a stow package in `launchd/` and loaded by `bootstrap.sh`.

```bash
# Manual equivalents
update-agents         # Run AI tools update now
update-system         # Run full system update now
update                # Run both
```

## Maintenance

```bash
update                # Full update: update-system + update-agents
update-agents         # Update AI tools (claude-code, gemini-cli, pi, skills)
update-system         # System update (brew, mise, macOS)
mise install          # Install/update all runtimes
mise upgrade          # Upgrade all mise-managed tools
brew bundle cleanup   # Find orphaned Homebrew packages
source ~/.config/fish/config.fish   # Reload fish config
tmux source-file ~/.tmux.conf       # Reload tmux (or prefix + r)
```

## VPS / Linux

Linux servers do not use Homebrew. Use the Ubuntu/Debian `Aptfile` for headless system packages and `mise` for cross-platform runtimes/tools.

```bash
sudo apt-get update
~/.dotfiles/bin/install-aptfile
curl https://mise.run | sh
mise install
~/.dotfiles/bin/install-linux-mise-tools
```

The `Aptfile` intentionally excludes macOS GUI apps/fonts, Homebrew tap-only tools, transitional packages, and fast-moving CLIs that are better managed by `mise` or vendor repositories. Linux-only mise tools are listed in `mise-linux-tools.txt` and exposed through wrappers in `~/.local/bin` so the shared `mise/config.toml` stays macOS-safe. Docker is commented out by default; prefer Docker's official apt repository for development servers.

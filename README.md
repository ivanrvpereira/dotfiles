# dotfiles

Modern dotfiles for macOS with Fish shell, Starship prompt, and contemporary CLI tools.

## Overview

This dotfiles repository provides a curated development environment featuring:

- **Fish shell** with Starship prompt
- **Modern CLI tools**: bat, eza, fd, ripgrep, zoxide, and more
- **mise** for runtime version management (Rust-based asdf replacement)
- **Tmux** configuration with vi-mode and Dracula theme
- **direnv** for project-specific environments
- **1Password CLI** integration for secrets management
- **Comprehensive Homebrew package management**

## Prerequisites

- macOS (tested on recent versions)
- [Homebrew](https://brew.sh/) package manager
- Admin/sudo access for initial setup

## Quick Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Install Packages

Install all packages from the Brewfile:

```bash
brew bundle --file=~/.dotfiles/Brewfile
```

Or use the included alias after Fish setup:

```bash
bb
```

### 3. Configure Shell

Link or source Fish configuration files in `~/.config/fish/config.fish`:

```fish
source ~/.dotfiles/activate.fish
source ~/.dotfiles/aliases.fish
source ~/.dotfiles/exports.fish
```

### 4. Symlink Config Files

Create symlinks for configuration files:

```bash
ln -sf ~/.dotfiles/gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/.dotfiles/inputrc ~/.inputrc
ln -sf ~/.dotfiles/curlrc ~/.curlrc
ln -sf ~/.dotfiles/wgetrc ~/.wgetrc
```

For direnv:

```bash
mkdir -p ~/.config/direnv
ln -sf ~/.dotfiles/direnvrc ~/.config/direnv/direnvrc
```

### 5. Reload Configuration

```bash
source ~/.config/fish/config.fish
```

## Key Features

### Modern CLI Replacements

Traditional tools are replaced with modern alternatives:

| Instead of | Use | Description |
|------------|-----|-------------|
| `cat` | `bat` | Syntax highlighting |
| `ls` | `eza` | Better formatting |
| `find` | `fd` | Faster, simpler |
| `grep` | `rg` | Ripgrep |
| `sed` | `sd` | Modern find/replace |
| `cd` | `z` | Smart directory jumping |
| `rm` | `trash` | Safe deletion |
| `vim` | `nvim` | Neovim |
| `top` | `btop` | Better resource monitor |

### Useful Aliases

- `update` - Full system update (macOS + Homebrew)
- `bb` - Brew bundle from Brewfile
- `cleanup` - Remove old Brew and system files
- Git aliases: `lg` (pretty log), `clean-local` (prune branches)

See `aliases.fish` for the complete list.

### Tmux Configuration

- Custom prefix: `Ctrl-a`
- Vi-mode navigation
- Dracula theme
- Window switching: `F1-F5`

Reload: `prefix + r`

## Maintenance

### Update All Packages

```bash
update
```

This runs system updates, Homebrew updates, upgrades, installs packages from Brewfile, and cleanup.

### Check for Missing Packages

```bash
brewcheck
```

Shows the difference between your Brewfile and currently installed packages. Lines with `>` indicate packages installed but not in Brewfile, lines with `<` indicate packages in Brewfile but not installed.

### Update Brewfile

After installing new packages:

```bash
brew bundle dump --force --file=~/.dotfiles/Brewfile
```

## Documentation

For detailed documentation on commands, configurations, and architecture, see [CLAUDE.md](CLAUDE.md).

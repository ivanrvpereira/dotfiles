# Shared POSIX environment — sourced by .bash_profile and .zprofile
# Keep Fish-specific config in exports.fish; this covers bash/zsh fallback

# ─── Homebrew ─────────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─── PATH (from shared ~/.dotfiles/paths) ─────────────────────
if [ -f ~/.dotfiles/paths ]; then
    while IFS= read -r line; do
        case "$line" in \#*|"") continue ;; esac
        line="${line/#\~/$HOME}"
        [ -d "$line" ] && export PATH="$line:$PATH"
    done < ~/.dotfiles/paths
fi

# ─── Environment variables ────────────────────────────────────
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR=nvim
# SSH agent: 1Password on GUI machines, system default on headless
if [ ! -f "$HOME/.config/headless" ]; then
    export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
fi

# ─── mise (runtime manager) ───────────────────────────────────
if command -v mise >/dev/null 2>&1; then
    if [ -n "$ZSH_VERSION" ]; then
        eval "$(mise activate zsh)"
    elif [ -n "$BASH_VERSION" ]; then
        eval "$(mise activate bash)"
    fi
fi

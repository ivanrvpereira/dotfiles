# Shared PATH entries (loaded before interactive shell)
eval "$(/opt/homebrew/bin/brew shellenv)"

if [ -f ~/.dotfiles/paths ]; then
    while IFS= read -r line; do
        case "$line" in \#*|"") continue ;; esac
        line="${line/#\~/$HOME}"
        [ -d "$line" ] && export PATH="$line:$PATH"
    done < ~/.dotfiles/paths
fi

# Source .bashrc for interactive shells
[ -f ~/.bashrc ] && . ~/.bashrc

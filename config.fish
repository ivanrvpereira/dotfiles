source ~/.dotfiles/exports.fish
source ~/.dotfiles/aliases.fish
source ~/.dotfiles/activate.fish

# Non-interactive: use mise shims for scripts and subshells
if not status is-interactive
    mise activate fish --shims | source
end

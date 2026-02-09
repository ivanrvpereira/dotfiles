set -l config_dir (dirname (status --current-filename))
source $config_dir/exports.fish
source $config_dir/aliases.fish
source $config_dir/activate.fish

# Non-interactive: use mise shims for scripts and subshells
if not status is-interactive
    mise activate fish --shims | source
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

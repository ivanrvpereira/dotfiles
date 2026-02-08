set -l config_dir (dirname (status --current-filename))
source $config_dir/exports.fish
source $config_dir/aliases.fish
source $config_dir/activate.fish

# Non-interactive: use mise shims for scripts and subshells
if not status is-interactive
    mise activate fish --shims | source
end

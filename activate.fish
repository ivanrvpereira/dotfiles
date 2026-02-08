if status is-interactive
    starship init fish | source
    mise activate fish | source
    source ~/.config/op/plugins.sh
end

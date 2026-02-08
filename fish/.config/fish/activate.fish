if status is-interactive
    starship init fish | source
    mise activate fish | source
    source ~/.config/op/plugins.sh

    # Atuin - encrypted shell history sync with SQLite storage
    if type -q atuin
        atuin init fish | source
    end
end

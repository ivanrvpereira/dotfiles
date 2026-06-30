if status is-interactive
    starship init fish | source
    mise activate fish | source
    test -f ~/.config/op/plugins.sh; and source ~/.config/op/plugins.sh

    # Atuin - encrypted shell history sync with SQLite storage
    if type -q atuin
        atuin init fish | source
    end

    # Tirith - terminal security guard
    if type -q tirith
        tirith init --shell fish | source
    end

    # grc (orefalo/grc) wraps `env` and pipes its output through cgrc, which prints
    # "Failed to find conf file: env" to stdout. tirith's Enter hook reads stdout
    # line 1 as its approval-file path, so that message poisons the handoff and every
    # command gets blocked ("approval file missing or unreadable, failing closed").
    # The env colorizer is useless anyway (no conf.env) — drop the wrapper.
    functions -q env; and functions --erase env
end

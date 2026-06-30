#############################################################
# MODERN CLI REPLACEMENTS (bind only when the tool exists)
#############################################################
# Each alias is guarded so a machine missing the modern tool
# (e.g. a minimal VPS) keeps a working coreutils command instead
# of a broken alias. Debian/Ubuntu rename some binaries, so we
# probe both names (bat/batcat, fd/fdfind).

# cat -> bat
if command -q bat
    alias cat='bat'
else if command -q batcat
    alias cat='batcat'
end

# find -> fd
if command -q fd
    alias find='fd'
else if command -q fdfind
    alias find='fdfind'
end

# cd -> zoxide (z/zi come from the zoxide.fish plugin)
if command -q zoxide
    alias cd='z'
    alias cdi='zi'
end

# du -> dua (interactive disk usage)
if command -q dua
    alias du='dua'
end

# Safe file operations
alias cp='cp -i'
alias mv='mv -i'

# ls -> eza, with a coreutils fallback so `ls` always works
if command -q eza
    alias ls='eza'
    alias l='eza -lbF --git'
    alias ll='eza -lbGF --git'
    alias la='eza -lbhHigUmuSa --time-style=long-iso --git'
    alias lt='eza --tree --level=2'
else
    alias l='ls -lF'
    alias ll='ls -lhF'
    alias la='ls -lAhF'
    alias lt='ls -R'
end

# Editor: prefer nvim, fall back to the system vim/vi
if command -q nvim
    alias vim='nvim'
    alias vi='nvim'
end

#############################################################
# ABBREVIATIONS (expand inline before execution)
#############################################################

# Git
abbr g git
abbr gs 'git status'
abbr ga 'git add'
abbr gc 'git commit'
abbr gp 'git push'
abbr gl 'git pull'
abbr gd 'git diff'
abbr lg lazygit
abbr mux tmuxinator

# Docker & Kubernetes
abbr d docker
abbr dco docker-compose
abbr k kubectl

# Navigation
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'

# Homebrew
abbr bb 'brew bundle --file=~/.dotfiles/Brewfile'

# Quick lookups
abbr myip 'curl -s https://ipinfo.io/ip'
abbr localip 'ipconfig getifaddr en0'
abbr weather 'curl wttr.in'
abbr speedtest speedtest-cli
abbr ports 'netstat -tulan'

#############################################################
# COMMANDS
#############################################################

# macOS
alias flush="sudo dscacheutil -flushcache; and sudo killall -HUP mDNSResponder"
alias privacy="open x-apple.systempreferences:com.apple.preference.security"
alias cleanup='fd -H -I ".DS_Store" -x /bin/rm {}'
alias search='rg -i'

# System update
alias update='update-system && update-agents'
alias update-agents='~/.dotfiles/bin/update-agents && ~/.agents/bin/sync --yes'

# Homebrew check
alias brewcheck='brew bundle dump --force --file=/tmp/Brewfile.current && diff ~/.dotfiles/Brewfile /tmp/Brewfile.current | grep "^>" | sd "^> " ""; rm -f /tmp/Brewfile.current'

# AI & tools
alias claudeyolo='claude --dangerously-skip-permissions'
alias cly=claudeyolo
alias codexyolo='codex --dangerously-bypass-approvals-and-sandbox'
if set -q DOTFILES_HEADLESS
    alias ubi='ubi'
else
    alias ubi='op run -- ubi'
end

# Authenticate ephemeral secrets (once per reboot, stored in TMPDIR)
function auth
    if set -q DOTFILES_HEADLESS
        echo "Headless machine — secrets loaded from ~/.secrets"
        test -f ~/.secrets; and source ~/.secrets
    else
        op read "op://development/exa-api-key/credential" 2>/dev/null | read -l _key
        or begin; echo "op read failed"; return 1; end
        test -n "$_key"; or begin; echo "Empty key returned"; return 1; end
        printf '%s' "$_key" > $TMPDIR/.exa-api-key
        chmod 600 $TMPDIR/.exa-api-key
        set -gx EXA_API_KEY "$_key"
        echo "Authenticated for this session"
    end
end

#############################################################
# SECRET DETECTION
#############################################################

alias secret-scan='gitleaks detect --source . --verbose --redact'
alias secret-scan-history='gitleaks git --source . --verbose --redact'
alias secret-scan-verified='trufflehog filesystem . --only-verified'
alias hooks-install='pre-commit install'
alias hooks-run='pre-commit run --all-files'

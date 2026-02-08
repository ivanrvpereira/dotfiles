#############################################################
# MODERN CLI REPLACEMENTS
#############################################################

alias cat='bat'
alias find='fd'
alias cd='z'
alias cdi='zi'
alias du='dua'

# Safe file operations
alias rm='trash'
alias del='/bin/rm'
alias cp='cp -i'
alias mv='mv -i'

# ls/eza variations
alias ls='eza'
alias l='eza -lbF --git'
alias ll='eza -lbGF --git'
alias la='eza -lbhHigUmuSa --time-style=long-iso --git'
alias lt='eza --tree --level=2'

# Editors
alias vim='nvim'
alias vi='nvim'

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
alias cleanup='fd -H -I ".DS_Store" -x rm {}'
alias search='rg -i'

# System update
alias update='sudo softwareupdate -i -a && brew update && brew upgrade && brew bundle --file=~/.dotfiles/Brewfile && brew cleanup && mise upgrade'
alias update-ai='brew upgrade gemini-cli claude-code && npm install -g @mariozechner/pi-coding-agent && claude && open x-apple.systempreferences:com.apple.preference.security'

# Homebrew check
alias brewcheck='brew bundle dump --force --file=/tmp/Brewfile.current && diff ~/.dotfiles/Brewfile /tmp/Brewfile.current | grep "^>" | sd "^> " ""; and rm /tmp/Brewfile.current'

# AI & tools
alias claudeyolo='/opt/homebrew/bin/claude --dangerously-skip-permissions'
alias cly=claudeyolo
alias codexyolo='codex --dangerously-bypass-approvals-and-sandbox'
alias ubi='op run -- ubi'

# Authenticate ephemeral secrets (once per reboot, stored in TMPDIR)
function auth
    op read "op://development/exa-api-key/credential" > $TMPDIR/.exa-api-key
    chmod 600 $TMPDIR/.exa-api-key
    set -gx EXA_API_KEY (cat $TMPDIR/.exa-api-key)
    echo "Authenticated for this session"
end

#############################################################
# SECRET DETECTION
#############################################################

alias secret-scan='gitleaks detect --source . --verbose --redact'
alias secret-scan-history='gitleaks git --source . --verbose --redact'
alias secret-scan-verified='trufflehog filesystem . --only-verified'
alias hooks-install='pre-commit install'
alias hooks-run='pre-commit run --all-files'

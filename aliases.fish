alias vim='nvim'
alias vi='nvim'
alias dco='docker-compose'
alias dcs='eval (docker-machine env promserver1)'

alias ls='gls --color=auto'

# Get week number
alias week='date +%V'


# python
alias pyserver='python -m SimpleHTTPServer'
alias rmpyc="find . -iname '*.pyc' -exec rm {} \;"

# bash stuff
alias df="df -h"
alias du="du -sh"
# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"


### OSX
alias flush="dscacheutil -flushcache; and killall -HUP mDNSResponder"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true; and killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false; and killall Finder"

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Get OS X Software Updates, and update installed Ruby gems, Homebrew, npm, and their installed packages
alias update='sudo softwareupdate -i -a; brew update; brew upgrade --all; brew cleanup; npm install npm -g; npm update -g; sudo gem update --system; sudo gem update'

alias code2='/Applications/Visual\ Studio\ Code\ -\ Insiders.app/Contents/Resources/app/bin/code'


# add /usr/local/sbin to your PATH Variable
#set -x PATH /usr/local/sbin $PATH
#set -x PATH /usr/local/bin $PATH
# gnu utils

# the order is important. the firsts precedes
fish_add_path /Applications/PyCharm.app/Contents/MacOS
fish_add_path /opt/homebrew/opt/openjdk@17/bin
fish_add_path $HOME/Library/Haskell/bin
set -x GOPATH $HOME/go
fish_add_path $GOPATH/bin
fish_add_path ~/.vector/bin

fish_add_path ~/.local/bin

fish_add_path /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path /opt/homebrew/sbin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/libpq/bin

set -x MANPATH /opt/homebrew/opt/coreutils/libexec/gnuman $MANPATH

set -x ENVIRONMENT development

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

set -x JAVA_HOME /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
set -gx UBI_TOKEN op://development/ubicloud-token/credential
set -x SSH_AUTH_SOCK $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# SECURITY: API key moved to 1Password - use: op read "op://development/perplexity-api-key/credential"
# set -x PERPLEXITY_API_KEY (op read "op://development/perplexity-api-key/credential")

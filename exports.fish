# add /usr/local/sbin to your PATH Variable
#set -x PATH /usr/local/sbin $PATH
#set -x PATH /usr/local/bin $PATH
# gnu utils
set -x PATH /opt/homebrew/opt/coreutils/libexec/gnubin $PATH
#set -x PATH /usr/local/opt/python/libexec/bin $PATH
set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/Library/Haskell/bin $PATH
set -x PATH $HOME/.poetry/bin $PATH
set -x PATH /Applications/PyCharm.app/Contents/MacOS $PATH
set -x PATH $HOME/.vector/bin $PATH

set -x GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin

set -x MANPATH /opt/homebrew/opt/coreutils/libexec/gnuman $MANPATH

set -x DJANGO_ENVIRONMENT dev
set -x ENVIRONMENT development
set -x FLASK_ENV dev

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8



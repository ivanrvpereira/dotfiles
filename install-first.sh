#!/bin/bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install git
ssh-keygen
cat .ssh/id_rsa.pub | pbcopy
echo "paste key on gitub"
read -p "Paste ssh key on GitHub"
git clone git@github.com:balsagoth/dotfiles.git .dotfiles

# Fish
brew install fish
# Note: Use /opt/homebrew/bin for Apple Silicon, /usr/local/bin for Intel
FISH_PATH=$(which fish)
sudo sh -c "echo $FISH_PATH >> /etc/shells"
chsh -s $FISH_PATH
set -U fish_user_paths /opt/homebrew/bin $fish_user_paths
curl -L https://get.oh-my.fish | fish
echo "restart shell"



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
sudo sh -c 'echo /usr/local/bin/fish >> /etc/shells'
chsh -s /usr/local/bin/fish
set -U fish_user_paths /usr/local/bin $fish_user_paths
curl -L https://get.oh-my.fish | fish
echo "restart shell"



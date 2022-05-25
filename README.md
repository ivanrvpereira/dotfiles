# dotfiles
My curated dotfiles. Vim + neovim + janus + zsh + oh-my-zsh +  nice colors

## Author

Ivan Pereira  
[@balsagoth](https://twitter.com/balsagoth)


Open a terminal.
Type the following command to change the primary hostname of your Mac:
This is your fully qualified hostname, for example myMac.domain.com

sudo scutil --set HostName <new host name>
Type the following command to change the Bonjour hostname of your Mac:
This is the name usable on the local network, for example myMac.local.

sudo scutil --set LocalHostName <new host name>
If you also want to change the computer name, type the following command:
This is the user-friendly computer name you see in Finder, for example myMac.

sudo scutil --set ComputerName <new name>
Flush the DNS cache by typing:

dscacheutil -flushcache


# Keychain migration
https://support.apple.com/en-gb/guide/keychain-access/kyca1121/mac
Copy login.keychain-db to ~/Library/Keychains/login-ANOTHERNAME.keychain-db
Go to keychain and add a new keychain.
Remember that this keychain has the encryption password of the original location


defaults write -g ApplePressAndHoldEnabled -bool false
https://gist.github.com/lsd/1e1826907ab7e49c536a


brew install graphviz
python -m pip install \
    --global-option=build_ext \
    --global-option="-I$(brew --prefix graphviz)/include/" \
    --global-option="-L$(brew --prefix graphviz)/lib/" \
    pygraphviz

## Thanks to…

* [Mathias Bynens](https://mathiasbynens.be/) - heavily inspered by [https://github.com/mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)

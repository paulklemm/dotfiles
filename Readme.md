# Dotfiles for Home folder of my Macbook

This repository contains the Dotfiles for my Macbook. It is inspired from the Blog post [https://coderwall.com/p/ynu8xq/keep-your-dotfiles-in-git](https://coderwall.com/p/ynu8xq/keep-your-dotfiles-in-git).

## Setup

I use

- ZSH with the [Oh-My-ZSH](https://github.com/robbyrussell/oh-my-zsh) configuration
- Autocompletion Plugin for Oh My ZSH: [https://github.com/zsh-users/zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) theme for ZSH with a custom configuration found in the `zshrc`
- [NORD tmux theme](https://github.com/arcticicestudio/nord-tmux)
- [Aerospace](https://github.com/nikitabobko/AeroSpace) window manager

## Usage

Navigate to the Home folder and run the following commands.

```bash
# Clone the Repo
git clone <REPO-NAME> ~/.dotfiles

# Create symlinks
ln -s ~/.dotfiles/bashrc ~/.bashrc
ln -s ~/.dotfiles/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/zshrc ~/.zshrc
ln -s ~/.dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/.dotfiles/p10k.zsh ~/.p10k.zsh
ln -s ~/.dotfiles/aerospace.toml ~/.aerospace.toml

# Clone tmux theme
cd ~/.dotfiles && git clone git@github.com:arcticicestudio/nord-tmux.git
# Clone fzf - https://github.com/junegunn/fzf#using-git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
# Only say "No" to "Update config files"
~/.fzf/install

# Install zsh syntax highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/plugins/zsh-syntax-highlighting

# Add the global gitignore file - https://stackoverflow.com/questions/7335420/global-git-ignore
git config --global core.excludesfile '~/.dotfiles/global_gitignore'
```

## Fonts

The Powerlevel10k settings are set up to work with nerdfont-complete fonts ([https://github.com/romkatv/powerlevel10k#fonts](https://github.com/romkatv/powerlevel10k#fonts)). For example, use [this one](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode/Regular) in the `complete` folder.

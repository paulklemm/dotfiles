# Dotfiles for Home folder of my Macbook

This repository contains the Dotfiles for my Macbook. It is inspired from the Blog post [https://coderwall.com/p/ynu8xq/keep-your-dotfiles-in-git](https://coderwall.com/p/ynu8xq/keep-your-dotfiles-in-git).

# Setup

I use

- ZSH with the [Oh-My-ZSH](https://github.com/robbyrussell/oh-my-zsh) configuration
- [Powerlevel9k](https://github.com/bhilburn/powerlevel9k) theme for ZSH with a custom configuration found in the `zshrc` 
- [Source Code Pro Powerline Font-Awesome patched font](https://github.com/gabrielelana/awesome-terminal-fonts/raw/patching-strategy/patched/SourceCodePro%2BPowerline%2BAwesome%2BRegular.ttf)

# Usage

Navigate to the Home folder and run the following commands.

```bash
# Clone the Repo
git clone <REPO-NAME> ~/.dotfiles

# Create symlinks
ln -s ~/.dotfiles/bashrc ~/.bashrc
ln -s ~/.dotfiles/bash_profile ~/.bash_profile
ln -s ~/.dotfiles/zshrc ~/.zshrc
```

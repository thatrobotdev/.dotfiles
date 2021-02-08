# .dotfiles

My personal dotfiles for macOS.

## What are dotfiles?

Dotfiles are configuration files like `.zshrc` or `.gitconfig` that configure programs on your computer. This repository is a collection of dotfiles that I am using to make re-installing macOS take way less time congiguring and remembering my settings for programs.

## Can I use your dotfile config?

Yeah! Keep in mind though that since these dotfiles contain configurations for me, you probably won't like what it does. Or the millions of applications installed in the [Brewfile](Brewfile).

It's also probably broken, old, not configured for your hardware/software, etc. 

I highly reccommend you look for other dotfiles intended for people to fork, or ones made with sensible defaults in mind.

## How it works

* `install.conf.yaml` congigures [dotbot](https://github.com/anishathalye/dotbot), a tool that bootstraps dotfiles.
* `install` is the install script, with a little bit of glue to get everything down in one command, working with dotbot.
* `.makeup.cfg` configures [Mackup](https://github.com/lra/mackup), a tool that backs up application settings and restores easily on fresh installs.
* `.zshrc` configures [Oh My ZSH](https://ohmyz.sh/), a really great framewordk for managina a Zsh configuration.
* `Brewfile` manages installed dependencies and programs that I would want to download on a fresh install.

## Install

1. Log-in to the Mac App Store

2:
```sh

# Install Brew + git if you don't have them installed
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
# brew install git

git clone https://github.com/thatrobotdev/.dotfiles.git ~/.dotfiles

cd ~/.dotfiles

./install
```

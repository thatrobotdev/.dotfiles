# .dotfiles

My personal dotfiles for macOS, and a packaged installation script for new OSX computers.

## What are dotfiles?

Dotfiles are configuration files like `.zshrc` or `.gitconfig` that configure programs on your computer. This repository is a collection of dotfiles that I am using to make re-installing macOS take way less time congiguring and remembering my settings for programs.

## Can I use your dotfile config?

Yeah! Keep in mind though that since these dotfiles contain configurations for me, you probably won't like what it does. Or the millions of applications installed in the [Brewfile](Brewfile).

## How it works

* `install.conf.yaml` congigures [dotbot](https://github.com/anishathalye/dotbot), a tool that bootstraps dotfiles.
* `install` is the install script, with a little bit of glue to get everything down in one command, working with dotbot.
* `.makeup.cfg` configures [Mackup](https://github.com/lra/mackup), a tool that backs up application settings and restores easily on fresh installs.
* `.zshrc` configures [Oh My ZSH](https://ohmyz.sh/), a really great framewordk for managina a Zsh configuration.
* `Brewfile` manages installed dependencies and programs that I would want to download on a fresh install.

## Install

1. Log-in with your Apple ID to the Mac App Store (to let install script download things from the Mac App Store)

2. Run the following code in Terminal:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/thatrobotdev/.dotfiles/main/install.sh)"


# Install Brew + git if you don't have them installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 

brew install git

# Clone repo, and run install script

git clone https://github.com/thatrobotdev/.dotfiles.git ~/.dotfiles

cd ~/.dotfiles

./install.sh
```

## Commands
Example usage: `./install.sh [-h, -n]`

All errors are typed in RED, installing is denoted in GREEN, and logging starts with the "⚙" symbol.

Options:
* `-h`, `--help`: displays description and options
* `-n`, `--no-homebrew`: skips Homebrew config when passed

## TODO
* Get install into one command
* Automatically type in passwords when prompted?
* Consolidate mackup and dotbot
* Get working on windows
* Clean up script for the ordering of items in the Brewfile
* Automatically assemble global .gitignore_global from https://github.com/github/gitignore
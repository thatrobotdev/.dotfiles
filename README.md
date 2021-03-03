# .dotfiles

My personal dotfiles for macOS, and a packaged installation script for new OSX computers.

## What are dotfiles?

Dotfiles are configuration files like `.zshrc` or `.gitconfig` that configure programs on your computer. This repository is a collection of dotfiles that I am using to make re-installing macOS take way less time congiguring and remembering my settings for programs.

## Can I use your dotfile config?

Yeah! Keep in mind though that since these dotfiles contain configurations for me, you probably won't like what it does. Or the millions of applications installed in the [Brewfile](Brewfile).

## How it works

- `install.conf.yaml` congigures [dotbot](https://github.com/anishathalye/dotbot), a tool that bootstraps dotfiles.
- `install.sh` is the install script, with a little bit of glue to get everything down in one command, working with dotbot.
- `pull.sh` aids in first-time installation (see [Install](##Install))
- `.makeup.cfg` configures [Mackup](https://github.com/lra/mackup), a tool that backs up application settings and restores easily on fresh installs.
- `.zshrc` configures [Oh My ZSH](https://ohmyz.sh/), a really great framewordk for managina a Zsh configuration.
- `Brewfile` manages installed dependencies and programs that I would want to download on a fresh install.

## Install

1. Log-in with your Apple ID to the Mac App Store (to let install script download things from the Mac App Store)

2. Make sure that a `~/.dotfiles` folder does not exist or is empty.

3. Run the following code in Terminal:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/thatrobotdev/.dotfiles/main/pull.sh)"
```

## Commands

Example usage: `./install.sh [-h, -n]`

All errors are typed in RED, installing is denoted in GREEN, and logging starts with the "⚙" symbol.

Options:

- `-h`, `--help`: displays description and options
- `-n`, `--no-homebrew`: skips Homebrew config when passed

## TODO

- Automatically type in passwords when prompted?
- Consolidate mackup and dotbot
- Get working on windows
- Clean up script for the ordering of items in the Brewfile
- Automatically assemble global .gitignore_global from <https://github.com/github/gitignore>

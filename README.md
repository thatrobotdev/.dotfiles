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

## Usage

Example usage: `./install.sh [command-line arguments]`

All logging from this script will be preceeded by a "⚙" character

If the script needs to get your attention, messages will be in CYAN (if your terminal supports it, you'll hear a sound). Errors are RED, and a new install is usually GREEN.

Options:

- `-h`, `--help`: displays description and options
- `-n`, `--no-homebrew`: skips Homebrew config when passed
- `-f`, `--first-time`: configures apps and runs scripts for first time set-up, run when running the install script for the first time

## TODO

- Consolidate mackup and dotbot
- Get working on windows
- Automatically assemble global .gitignore_global from <https://github.com/github/gitignore>
- Move all data away from install.sh into seperate files, and keep all data in a separate folder

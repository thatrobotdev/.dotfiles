# .dotfiles

My personal dotfiles for macOS.

## What are dotfiles?

Dotfiles are configuration files like `.zshrc` or `.gitconfig` that configure programs on your computer. This repository is a collection of dotfiles that I am using to make re-installing macOS take way less time congiguring and remembering my settings for programs.

## On a new computer

1. Install [Homebrew](https://brew.sh/) (package manager)

```sh
# https://brew.sh/
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install [GitHub Desktop](https://desktop.github.com/)

```sh
# https://formulae.brew.sh/cask/github
brew install --cask github
```

3. Clone this repository
4. Create a symbolic link for the desired `Brewfile` and `Brewfile.json.lock` files.

```sh
ln -s ln -s /Users/<user>/Documents/GitHub/.dotfiles/<environment>/Brewfile.lock.json Brewfile
ln -s ln -s /Users/<user>/Documents/GitHub/.dotfiles/<environment>/Brewfile.lock.json Brewfile.lock.json
```

5. Sync upstream Brewfile with local software
```sh
brew bundle --force cleanup
```

6. Install software
```sh
brew bundle
```
#!/usr/bin/env bash

# Color
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "⚙ Welcome to first time set-up! This will download Homebrew, git, and clone the install script."
echo "⚙ Make sure that no ~/.dotfiles folder exists, or that it is empty for the script to clone properly."
echo "⚙ In the future, just re-run the install.sh command using ./install.sh in the ~/.dotfiles folder."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
    echo -e "${GREEN}⚙ Installing Homebrew${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    echo "⚙ Homebrew found."
fi

brew install git

# Clone repo, and run install script

git clone https://github.com/thatrobotdev/.dotfiles.git ~/.dotfiles

cd ~/.dotfiles

./install.sh
#!/usr/bin/env bash

# Color
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly RED='\033[0;31m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

display_help () {
  echo "Example usage:"
  echo "  ./install [-h, -n]"
  echo;
  echo "Installs or updates configuration dotfiles for macOS."
  echo -e "All errors are typed in ${RED}RED${NC}, installing is denoted in ${GREEN}GREEN${NC}, and logging starts with the \"⚙\" symbol."
  echo;
  echo "Options:"
  echo "  -h, --help          displays description and options"
  echo "  -n, --no-homebrew   skips Homebrew config when passed"
}

while :
do
  case "$1" in
    -h | --help)
      display_help
      exit 0
      ;;
    -n | --no-homebrew)
      nohomebrew="nohomebrew"
      shift
      ;;
    # --) # End of all options
    #   shift
    #   break;
    -*)
      echo -e "${RED}⚙ Error: Unknown option: $1" >&2
      exit 1
      ;;
    *) # No more options
      break
      ;;
  esac
done

echo "⚙ Setting up your Mac... (get help with \"-h\" or \"--help\")"

# Homebrew config if user doesn't pass a -nh or --no-homebrew argument
if [ "$nohomebrew" ]; then
    echo "⚙ Skipping Homebrew recipe update."
    else

    echo "⚙ Starting Homebrew config..."
    
    # Check for Homebrew and install if we don't have it
    if test ! "$(which brew)"; then
        echo -e "${GREEN}⚙ Installing Homebrew${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
      echo "⚙ Homebrew found."
    fi
    
    echo "⚙ Updating Homebrew..."
    brew update

    echo "⚙ Upgrade outdated casks and outdated, unpinned formulae..."
    brew upgrade

    # Check if Apple Command Line tools are installed, and prompt installation if not.
    if type xcode-select >&- && xpath=$( xcode-select --print-path ) &&
      test -d "${xpath}" && test -x "${xpath}" ; then
      echo "⚙ Apple Command Line Tools found."
    else
      echo -e "${GREEN}⚙ Installing Apple Command Line Tools${NC}"
      xcode-select --install
      printf "%s⚙ Press any key to continue when you are done with installation.%s" "${CYAN}" "${NC}"
      read -n 1 -s -r -p ""
      echo;
    fi

    # Install all our dependencies with bundle (See Brewfile)
    echo "⚙ Installing all our dependencies with bundle..."
    brew tap homebrew/bundle
    brew bundle

    echo -e "${CYAN}⚙ Allow system Java wrappers to find JDKs (password may be required)${NC}"
    sudo ln -sfn "$(brew --prefix)"/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
    sudo ln -sfn "$(brew --prefix)"/opt/openjdk@8/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
fi
shift

# Install Oh My ZSH (https://github.com/ohmyzsh/ohmyzsh) if it isn't installed 

if [ ! -d "$HOME"/.oh-my-zsh ]; then
  echo -e "${GREEN}⚙ Installing Oh My ZSH...${NC}"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "⚙ Oh My ZSH found."
fi

echo "Downloading/Updating iTerm2 Color Preset"

readonly ITERM2_MATERIAL_DESIGN_DIR='iterm2-material-design' # No Color

git -C "${ITERM2_MATERIAL_DESIGN_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${ITERM2_MATERIAL_DESIGN_DIR}"

echo "⚙ Installing iTerm2 Color Preset..."
open iterm2-material-design/material-design-colors.itermcolors

echo -e "${YELLOW}⚙ To finish set-up for the color preset, follow these instructions:${NC}"
echo "1. Go to iTerm2 > Preferences > Profiles > Colors"
echo "2. Click Color Presets..."
echo "3. Select the material-design-colors from Load Presets"

# Dotbot
echo "⚙ Booting up Dotbot..."

########################################################
### FROM DOTBOT INSTALL FILE

set -e

CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

########################################################

# Restoring macOS configs with mackup
echo "⚙ Restoring macOS configs with mackup..."
mackup restore

echo "⚙ Backing up current configuration..."
mackup backup

echo "⚙ Ayy we good"
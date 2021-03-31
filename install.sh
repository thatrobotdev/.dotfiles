#!/bin/bash
set -u

# Color
readonly GREEN='\033[0;32m'
readonly RED='\033[0;31m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color / Color Reset

abort() {
  printf "${RED}⚙ Error: %s\n${NC}" "$@"
  exit 1
}

chomp() { # Remove newline characters from the end of any string
  printf "%s" "${1/"$'\n'"/}"
}

message() {
  printf "⚙ %s\n" "$(chomp "$1")"
}

log_unstyled() {
  printf "%s\n" "$(chomp "$1")"
}

log_install() {
  printf "${GREEN}⚙ %s\n${NC}" "$(chomp "$1")"
}

log_attention() {
  printf "${CYAN}⚙ %s\n${NC}" "$(chomp "$1")"
  ring_bell
}

ring_bell() {         # Use the shell's audible bell
  if [[ -t 1 ]]; then # If attached to a terminal
    printf "\a"
  fi
}

display_help() {
  log_unstyled "Example usage:"
  log_unstyled "  ./install [command-line arguments]"
  log_unstyled
  log_unstyled "Installs or updates configuration dotfiles for macOS."
  log_unstyled "All logging from this script will be preceeded by a \"⚙\" character"
  log_unstyled -e "If the script needs to get your attention, messages will be in ${CYAN}CYAN${NC}"
  log_unstyled "(if your terminal supports it, you'll hear a sound)."
  log_unstyled -e "Errors are ${RED}RED${NC}, and a new install is usually ${GREEN}GREEN${NC}."
  log_unstyled
  log_unstyled "Options:"
  log_unstyled "  -h, --help          displays description and options"
  log_unstyled "  -n, --no-homebrew   skips Homebrew config when passed"
  log_unstyled "  -f --first-time     configured apps and runs scripts for"
  log_unstyled "                      first-time set-up, run when running"
  log_unstyled "                      the install script for the first time."
}

# Abort if Bash isn't installed
if [ -z "${BASH_VERSION:-}" ]; then
  abort "Bash is required to interpret this script."
fi

# Abort if not on macOS
OS="$(uname)"
if [[ "$OS" != "Darwin" ]]; then
  abort "This script only supports macOS."
fi

while :; do
  case "${1-}" in
  -h | --help)
    display_help
    exit 0
    ;;
  -n | --no-homebrew)
    readonly nohomebrew="nohomebrew"
    shift
    ;;
  -f | --first-time)
    readonly firsttime="firsttime"
    shift
    ;;
  # --) # End of all options
  #   shift
  #   break;
  -*)
    abort "Unknown option: ${1-}" >&2
    ;;
  *) # No more options
    break
    ;;
  esac
done

message "Setting up your Mac... (get help with \"-h\" or \"--help\")"

# Start Homebrew config if user doesn't pass a -nh or --no-homebrew argument
if [ "${nohomebrew-}" ]; then
  log_attention "Skipping Homebrew config."
else

  message "Starting Homebrew config..."

  # Check for Homebrew and install if we don't have it
  if test ! "$(which brew)"; then
    log_install "Installing Homebrew"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  else
    message "Homebrew found."
  fi

  log_install "Updating Homebrew..."
  brew update

  log_install "Upgrading outdated casks and outdated, unpinned formulae..."
  brew upgrade

  # Check if Apple Command Line tools are installed, and prompt installation if not.
  if type xcode-select >&- && xpath=$(xcode-select --print-path) &&
    test -d "${xpath}" && test -x "${xpath}"; then
    message "Apple Command Line Tools found."
  else
    log_install "Installing Apple Command Line Tools"
    xcode-select --install
    log_attention "Press any key to continue when you are done with installation."
    read -n 1 -s -r -p ""
    log_unstyled
  fi

  # Install all our dependencies with bundle (See Brewfile)
  log_install "Installing Applications and Dependencies..."
  brew tap homebrew/bundle
  brew bundle

  log_attention "Allowing system Java wrappers to find JDKs (password may be required).."
  sudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
  sudo ln -sfn /usr/local/opt/openjdk@8/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk

fi
shift

# Install Oh My ZSH (https://github.com/ohmyzsh/ohmyzsh) if it isn't installed

if [ ! -d "$HOME"/.oh-my-zsh ]; then
  log_install "Installing Oh My ZSH..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  message "Oh My ZSH found."
fi

if [ "${firsttime-}" ]; then

  log_attention "Starting first-time configuration for some programs..."

  # Configuring iTerm2

  log_install "Installing/Updating iTerm2 Color Preset"

  readonly ITERM2_MATERIAL_DESIGN_DIR='iterm2-material-design' # No Color

  git -C "${ITERM2_MATERIAL_DESIGN_DIR}" submodule sync --quiet --recursive
  git submodule update --init --recursive "${ITERM2_MATERIAL_DESIGN_DIR}"

  log_install "Installing iTerm2 Color Preset..."
  open iterm2-material-design/material-design-colors.itermcolors

  log_attention "To finish set-up for the color preset, follow these instructions:"
  message "1. Go to iTerm2 > Preferences > Profiles > Colors"
  message "2. Click Color Presets..."
  message "3. Select the material-design-colors from Load Presets"

  log_install "Downloading iTerm 2 Shell Integration"
  curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

  # Configure Anki

  # https://github.com/FooSoft/anki-connect#notes-for-mac-os-x-users
  log_install "Configuring Anki to disable AppNap for Anki Connect..."
  defaults write net.ankiweb.dtop NSAppSleepDisabled -bool true
  defaults write net.ichi2.anki NSAppSleepDisabled -bool true
  defaults write org.qt-project.Qt.QtWebEngineCore NSAppSleepDisabled -bool true

  message "First-time configuration for some programs finished."

fi

log_install "Installing/Updating VS Code extensions"
declare -a extensions=(
  "DavidAnson.vscode-markdownlint"
  "dbaeumer.vscode-eslint"
  "eg2.vscode-npm-script"
  "esbenp.prettier-vscode"
  "fabiospampinato.vscode-projects-plus"
  "foxundermoon.shell-format"
  "GitHub.vscode-pull-request-github"
  "kiteco.kite"
  "ms-python.python"
  "ms-vscode.cpptools"
  "rebornix.ruby"
  "thisotherthing.vscode-todo-list"
  "timonwong.shellcheck"
  "vsciot-vscode.vscode-arduino"
  "wingrunr21.vscode-ruby"
)

for extension in "${extensions[@]}"; do
  code --install-extension "${extension}" --force
done

# Dotbot
message "Booting up Dotbot..."

########################################################
### FROM DOTBOT INSTALL FILE

set -e +u

CONFIG="install.conf.yaml"
DOTBOT_DIR="dotbot"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "${BASEDIR}"
git -C "${DOTBOT_DIR}" submodule sync --quiet --recursive
git submodule update --init --recursive "${DOTBOT_DIR}"

"${BASEDIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASEDIR}" -c "${CONFIG}" "${@}"

set +e -u

########################################################

# Restoring macOS configs with mackup
log_install "Restoring macOS configs with mackup..."
mackup restore

log_install "Backing up current configuration..."
mackup backup

log_attention "Ayy we good"

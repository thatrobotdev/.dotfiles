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

message "Starting set-up :) (get help with \"-h\" or \"--help\")"

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

fi
shift

# Install Oh My ZSH (https://github.com/ohmyzsh/ohmyzsh) if it isn't installed

if [ ! -d "$HOME"/.oh-my-zsh ]; then
  log_install "Installing Oh My ZSH..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  message "Oh My ZSH found."
fi

log_install "Installing/Updating VS Code extensions"
./install/vscode-extensions.sh

log_attention "Ayy we good"

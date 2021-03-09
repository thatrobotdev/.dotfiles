# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme (See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
ZSH_THEME="robbyrussell"

# Automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code -w'
fi

# Aliases

alias gll='git log --graph --pretty=oneline --abbrev-commit'

# Antigen
source $(brew --prefix)/share/antigen/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle zsh-users/zsh-completions

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
antigen theme robbyrussell

# Tell Antigen that you're done.
antigen apply

# Add iTerm 2 Shell Integration
source ~/.iterm2_shell_integration.zsh

#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Installs vscode extensions

declare -a extensions=(
    "vsciot-vscode.vscode-arduino"
    "ms-vscode.cpptools"
    "dbaeumer.vscode-eslint"
    "github.vscode-pull-request-github"
    "ms-toolsai.jupyter"
    "kiteco.kite"
    "ms-vsliveshare.vsliveshare"
    "davidanson.vscode-markdownlint"
    "eg2.vscode-npm-script"
    "esbenp.prettier-vscode"
    "fabiospampinato.vscode-projects-plus"
    "ms-python.python"
    "rebornix.ruby"
    "foxundermoon.shell-format"
    "timonwong.shellcheck"
    "thisotherthing.vscode-todo-list"
    "wingrunr21.vscode-ruby"

)

for extension in "${extensions[@]}"; do
    code --install-extension "${extension}" --force
done

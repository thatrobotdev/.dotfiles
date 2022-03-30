#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# Installs vscode extensions

declare -a extensions=(
    ""
)

for extension in "${extensions[@]}"; do
    code --install-extension "${extension}" --force
done

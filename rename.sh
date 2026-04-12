#!/bin/bash
# ==============================================================================
# T-Header: Rename Tool (Zsh Version)
# ==============================================================================
# Safely updates the custom name in Zsh configuration.
# ==============================================================================

set -euo pipefail

log_info() { echo -e "\e[34m[INFO]\e[0m $1"; }
log_success() { echo -e "\e[32m[SUCCESS]\e[0m $1"; }
log_error() { echo -e "\e[31m[ERROR]\e[0m $1"; exit 1; }

echo
read -p "Enter new custom name for your terminal: " new_name

if [[ -z "$new_name" ]]; then
    log_error "Name cannot be empty."
    exit 1
fi

new_name=$(echo "$new_name" | tr -dc '[:alnum:] -')

# Update .zshrc
if [ -f "$HOME/.zshrc" ]; then
    log_info "Updating TNAME in .zshrc..."
    sed -i "s/export TNAME=\".*\"/export TNAME=\"$new_name\"/g" "$HOME/.zshrc"
    log_success "Custom name updated to: $new_name"
else
    log_error ".zshrc not found."
fi

echo "Changes will take effect in the next terminal session."
exec zsh

#!/bin/bash
# Define a function that runs a command with sudo if possible and needed
sudo_if_possible() {
  # Check if sudo is available
  if command -v sudo >/dev/null 2>&1; then
    # Check if the user is not root
    if [[ "$EUID" -ne 0 ]]; then
      # Run the command with sudo
      sudo "$@"
    else
      # Run the command without sudo
      "$@"
    fi
  else
    # Run the command without sudo
    "$@"
  fi
# follow his instructions on his GitHub remo7777
install_remo_version() {
  sudo_if_possible apt update
  sudo_if_possible apt upgrade -y
  sudo_if_possible apt install git -y
  git clone https://github.com/remo7777/T-Header.git $HOME/T-Header
  bash $HOME/T-Header/t-header.sh
}

install_remo_version
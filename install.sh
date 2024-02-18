#!/bin/bash
# Define a function that runs a command with sudo if possible and needed
sudo_if_possible() {
  # Check if sudo is available
  if command -v sudo >/dev/null 2>&1; then
    # Check if the user is not root
    if [ "$EUID" -ne 0 ]; then
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
}

sudo_if_possible apt update -y
sudo_if_possible apt upgrade -y
sudo_if_possible apt install git -y
sudo_if_possible rm -rdf $HOME/T-Header
sudo_if_possible git clone https://github.com/ManiacBoy777/T-Header.git

cd $HOME/ &

echo "";
echo -e "\e[1;34m[ ] \e[32mInstalling packages \e[0m";
(sudo_if_possible apt update -y && sudo_if_possible apt upgrade -y && sudo_if_possible apt install figlet pv binutils coreutils wget git zsh procps gawk exa neofetch python3 lolcat libncurses5-dev libncursesw5-dev -y) &> /dev/null; 
sudo_if_possible rm -f /etc/pam.d/chsh && sudo_if_possible cp $HOME/T-Header/chsh /etc/pam.d/chsh && sudo_if_possible chmod +x $HOME/T-Header/uninstall.sh && sudo_if_possible chmod +x $HOME/T-Header/rename.py && sudo_if_possible bash $HOME/T-Header/t-header.sh

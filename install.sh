#!/bin/bash
su - root &
cd /root/ &
apt update -y &&
apt upgrade -y &&
apt install figlet pv binutils coreutils wget git zsh procps gawk exa neofetch lolcat libncurses5-dev libncursesw5-dev -y &&
rm -f /etc/pam.d/chsh &&
cp $HOME/T-Header/chsh /etc/pam.d/chsh &&
chmod +x $HOME/T-Header/uninstall.sh
bash $HOME/T-Header/t-header.sh

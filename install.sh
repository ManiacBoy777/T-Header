#!/bin/bash
echo "";
echo -e "\e[1;34m[ ] \e[32mInstalling packages \e[0m";
echo "";
su - root &
cd $HOME/ &
apt update -y &&
apt upgrade -y &&
apt install figlet pv binutils coreutils wget git zsh procps gawk exa neofetch lolcat libncurses5-dev libncursesw5-dev -y &&
rm -f /etc/pam.d/chsh &&
cp $HOME/T-Header/chsh /etc/pam.d/chsh &&
chmod +x $HOME/T-Header/uninstall.sh
bash $HOME/T-Header/t-header.sh

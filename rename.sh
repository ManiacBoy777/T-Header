#!/bin/bash
clear
read -p "Enter new name: " PROC

sed -i "s/TNAME=\".*\"/TNAME=\"$PROC\"/" $HOME/.zshrc

source $HOME/.zshrc
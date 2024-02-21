#!/bin/bash
read -p "Enter new name: " PROC

sed -i "s/TNAME=\".*\"/TNAME=\"$PROC\"/" ~/.zshrc

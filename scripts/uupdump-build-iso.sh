#!/bin/bash

sudo apt install aria2 cabextract wimtools chntpw -y 
sudo apt install unzip -y 

unzip "$UUPDUMP_ZIP".zip
cd $UUPDUMP_ZIP
sh uup_download_linux.sh
ls -l *.iso
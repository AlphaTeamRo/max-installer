#!/bin/bash

read -r -p "Who was the script installed as ? ? (User, not root): " install_user

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script must be run as root. Exiting..."
    exit
fi

#disable and delete services

#stop
systemctl stop face.service
systemctl stop voice.service
systemctl stop discord.service
systemctl stop appsocket.service

#disable
systemctl disable face.service
systemctl disable voice.service
systemctl disable discord.service
systemctl disable appsocket.service

#delete
rm /lib/systemd/system/face.service
rm /lib/systemd/system/voice.service
rm /lib/systemd/system/discord.service
rm /lib/systemd/system/appsocket.service

#delete the max-scripts folder
rm -rf /home/$install_user/max-scripts

#ask for reinstall
read -r -p "Do you want to reinstall? [y/N]: " reinstall_response

if [[ "$reinstall_response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    apt update && apt -y install curl && curl https://raw.githubusercontent.com/AlphaTeamRo/max-installer/main/max-scripts/run.sh | bash && cd max-scripts && ./setup
else
    echo "Ok. Max software will not be installed. Exiting..."
    exit
fi
#!/bin/bash

read -r -p "Who are you installing as ? (User, not root): " install_user

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "This script must be run as root. Exiting..."
    exit
fi

if [[ $PWD != "/home/$install_user/max-scripts" ]]; then
    echo "Wrong directory. Make sure you are in /home/$install_user/max-scripts. Exiting..."
    exit
fi

read -r -p "Do you want to enable the max services? [y/N]: " services_response

#install git
apt-get -y update
apt-get -y install git

#pull from github
git clone https://github.com/AlphaTeamRo/app-socket-server
git clone https://github.com/AlphaTeamRo/max-discord-bot
git clone https://github.com/AlphaTeamRo/max-facerec-v2
git clone https://github.com/AlphaTeamRo/max_voice

#install apt dependencies
apt-get -y install espeak-ng
apt-get -y install flac
apt-get -y install portaudio19-dev
apt-get -y install vlc
apt-get -y install python3-pip
apt-get -y install cmake

#install pip dependencies

wget https://raw.githubusercontent.com/AlphaTeamRo/max-installer/main/max-scripts/requirements.txt -P /home/$install_user/max-scripts

runuser -l $install_user -c "python3 -m pip install youtube_dl"
runuser -l $install_user -c "python3 -m pip install -r $PWD/requirements.txt"

#create services

#face service

printf "Description=Executarea face la pornire
[Service]
Environment=XDG_RUNTIME_DIR=/run/user/1000
ExecStart=/bin/bash -c 'python3 -u /home/$install_user/max-scripts/max-facerec-v2/face.py'
WorkingDirectory=/home/$install_user/max-scripts/max-facerec-v2
Restart=always
User=$install_user
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/face.service

#voice service

printf "Description=Executarea voice la pornire
[Service]
Environment=XDG_RUNTIME_DIR=/run/user/1000
ExecStart=/bin/bash -c 'python3 -u /home/$install_user/max-scripts/max_voice/max_voice.py'
WorkingDirectory=/home/$install_user/max-scripts/max_voice
Restart=always
User=$install_user
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/voice.service

#discord service

printf "Description=Executarea discord-bot la pornire
[Service]
Environment=XDG_RUNTIME_DIR=/run/user/1000
ExecStart=/bin/bash -c 'python3 -u /home/$install_user/max-scripts/max-discord-bot/main.py'
WorkingDirectory=/home/$install_user/max-scripts/max-discord-bot
Restart=always
User=$install_user
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/discord.service

#app socket server service

printf "Description=Executarea serverului pentru aplicatie la pornire
[Service]
Environment=XDG_RUNTIME_DIR=/run/user/1000
ExecStart=/bin/bash -c 'python3 -u /home/$install_user/max-scripts/app-socket-server/socketserver.py'
WorkingDirectory=/home/$install_user/max-scripts/app-socket-server
Restart=always
User=$install_user
[Install]
WantedBy=multi-user.target" > /lib/systemd/system/appsocket.service

#enable services

if [[ "$services_response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    systemctl enable face.service
    systemctl enable voice.service
    systemctl enable discord.service
    systemctl enable appsocket.service
else
    echo "Ok. Services will not be enabled. Exiting..."
    exit
fi